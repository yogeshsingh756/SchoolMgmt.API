-- Procedure: sp_Admin_Payments_Collect
-- TermFee: proportional split across ClassFeeMaster fee types; OldFee: update StudentOldFee.PaidAmount

DROP PROCEDURE IF EXISTS `sp_Admin_Payments_Collect`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Payments_Collect` (
  IN `p_OrganizationId` INT,
  IN `p_StudentId` INT,
  IN `p_SessionId` INT,
  IN `p_PaymentTarget` VARCHAR(20),
  IN `p_PaymentDate` DATETIME,
  IN `p_PaymentMode` VARCHAR(20),
  IN `p_ReferenceNo` VARCHAR(50),
  IN `p_Notes` VARCHAR(255),
  IN `p_TotalPaidAmount` DECIMAL(10,2),
  IN `p_CreatedBy` INT
)
proc_label: BEGIN
  DECLARE v_PaymentId INT;
  DECLARE v_ReceiptNo VARCHAR(50);
  DECLARE v_ClassId INT;
  DECLARE v_SectionId INT;
  DECLARE v_YearlyTotal DECIMAL(10,2) DEFAULT 0;
  DECLARE v_TermPaid DECIMAL(10,2) DEFAULT 0;
  DECLARE v_TermLeft DECIMAL(10,2) DEFAULT 0;
  DECLARE v_OldFeeId INT;
  DECLARE v_OldTotal DECIMAL(10,2) DEFAULT 0;
  DECLARE v_OldPaid DECIMAL(10,2) DEFAULT 0;
  DECLARE v_OldLeft DECIMAL(10,2) DEFAULT 0;
  DECLARE v_RemainTotal DECIMAL(10,2) DEFAULT 0;
  DECLARE v_AllocatedSum DECIMAL(10,2) DEFAULT 0;
  DECLARE v_HasSectionScoped INT DEFAULT 0;
  DECLARE v_LastClassFeeId INT;
  DECLARE v_LastFeeTypeId INT;
  DECLARE v_LastTermId INT;
  DECLARE v_Concession DECIMAL(10,2) DEFAULT 0;
  DECLARE v_YearlyNet DECIMAL(10,2) DEFAULT 0;

  SET p_SessionId = NULLIF(p_SessionId, 0);
  SET p_PaymentTarget = IFNULL(p_PaymentTarget, 'TermFee');

  IF IFNULL(p_TotalPaidAmount, 0) <= 0 THEN
    SELECT 0 AS SuccessFlag, 'Invalid payment amount.' AS Message, NULL AS PaymentId, NULL AS ReceiptNo, 0 AS Allocated, 0 AS Unallocated;
    LEAVE proc_label;
  END IF;

  SELECT CurrentClassId, CurrentSectionId INTO v_ClassId, v_SectionId
  FROM Students
  WHERE UserId = p_StudentId AND OrganizationId = p_OrganizationId AND IsDeleted = 0
  LIMIT 1;

  IF v_ClassId IS NULL THEN
    SELECT 0 AS SuccessFlag, 'Student not found.' AS Message, NULL AS PaymentId, NULL AS ReceiptNo, 0 AS Allocated, 0 AS Unallocated;
    LEAVE proc_label;
  END IF;

  IF p_PaymentTarget = 'OldFee' THEN
    SELECT OldFeeId, TotalAmount, PaidAmount INTO v_OldFeeId, v_OldTotal, v_OldPaid
    FROM StudentOldFee
    WHERE OrganizationId = p_OrganizationId AND StudentId = p_StudentId AND IsDeleted = 0
    LIMIT 1;

    SET v_OldLeft = GREATEST(IFNULL(v_OldTotal,0) - IFNULL(v_OldPaid,0), 0);
    IF v_OldFeeId IS NULL OR v_OldLeft <= 0 THEN
      SELECT 0 AS SuccessFlag, 'No old fee balance for this student.' AS Message, NULL AS PaymentId, NULL AS ReceiptNo, 0 AS Allocated, 0 AS Unallocated;
      LEAVE proc_label;
    END IF;
    IF p_TotalPaidAmount > v_OldLeft THEN
      SELECT 0 AS SuccessFlag, 'Amount exceeds old fee left.' AS Message, NULL AS PaymentId, NULL AS ReceiptNo, 0 AS Allocated, 0 AS Unallocated;
      LEAVE proc_label;
    END IF;

    INSERT INTO ReceiptSequence (OrganizationId, LastNumber)
    VALUES (p_OrganizationId, 1)
    ON DUPLICATE KEY UPDATE LastNumber = LastNumber + 1, ModifiedOn = NOW();
    SELECT LastNumber INTO @seq FROM ReceiptSequence WHERE OrganizationId = p_OrganizationId;
    SET v_ReceiptNo = CONCAT('RCPT-', DATE_FORMAT(p_PaymentDate,'%Y%m'), '-', LPAD(@seq,6,'0'));

    INSERT INTO FeePayment
      (OrganizationId, StudentId, PaymentTarget, SessionId, ReceiptNo, PaymentDate, PaymentMode, ReferenceNo, Notes, TotalPaidAmount, CreatedBy)
    VALUES
      (p_OrganizationId, p_StudentId, 'OldFee', p_SessionId, v_ReceiptNo, p_PaymentDate, p_PaymentMode, p_ReferenceNo, p_Notes, p_TotalPaidAmount, p_CreatedBy);
    SET v_PaymentId = LAST_INSERT_ID();

    INSERT INTO FeePaymentAllocation
      (OrganizationId, PaymentId, InvoiceId, InvoiceItemId, ClassFeeId, FeeTypeId, TermId, OldFeeId, AllocatedAmount)
    VALUES
      (p_OrganizationId, v_PaymentId, NULL, NULL, NULL, NULL, NULL, v_OldFeeId, p_TotalPaidAmount);

    UPDATE StudentOldFee SET PaidAmount = PaidAmount + p_TotalPaidAmount, ModifiedOn = NOW() WHERE OldFeeId = v_OldFeeId;

    SELECT 1 AS SuccessFlag, 'Old fee payment recorded.' AS Message, v_PaymentId AS PaymentId, v_ReceiptNo AS ReceiptNo,
           p_TotalPaidAmount AS Allocated, 0 AS Unallocated;
    LEAVE proc_label;
  END IF;

  SELECT COUNT(*) INTO v_HasSectionScoped
  FROM ClassFeeMaster
  WHERE OrganizationId = p_OrganizationId AND ClassId = v_ClassId
    AND SectionId = v_SectionId AND IsDeleted = 0 AND IsActive = 1
    AND (p_SessionId IS NULL OR SessionId = p_SessionId);

  DROP TEMPORARY TABLE IF EXISTS tmp_fee_lines;
  CREATE TEMPORARY TABLE tmp_fee_lines AS
  SELECT
    cfm.ClassFeeId,
    cfm.FeeTypeId,
    cfm.TermId,
    cfm.DueDate,
    cfm.Amount AS LineAmount,
    GREATEST(cfm.Amount - IFNULL((
      SELECT SUM(a.AllocatedAmount)
      FROM FeePaymentAllocation a
      INNER JOIN FeePayment p ON p.PaymentId = a.PaymentId
      WHERE p.OrganizationId = p_OrganizationId
        AND p.StudentId = p_StudentId
        AND p.PaymentTarget = 'TermFee'
        AND a.ClassFeeId = cfm.ClassFeeId
        AND (p_SessionId IS NULL OR p.SessionId = p_SessionId OR p.SessionId IS NULL)
    ), 0), 0) AS LineRemain
  FROM ClassFeeMaster cfm
  WHERE cfm.OrganizationId = p_OrganizationId
    AND cfm.ClassId = v_ClassId
    AND cfm.IsDeleted = 0
    AND cfm.IsActive = 1
    AND (p_SessionId IS NULL OR cfm.SessionId = p_SessionId)
    AND (
      (v_HasSectionScoped > 0 AND cfm.SectionId = v_SectionId)
      OR (v_HasSectionScoped = 0 AND (cfm.SectionId IS NULL OR v_SectionId IS NULL))
    );

  SELECT IFNULL(SUM(LineAmount),0), IFNULL(SUM(LineRemain),0)
    INTO v_YearlyTotal, v_RemainTotal
  FROM tmp_fee_lines;

  SELECT IFNULL(SUM(TotalPaidAmount),0) INTO v_TermPaid
  FROM FeePayment
  WHERE OrganizationId = p_OrganizationId
    AND StudentId = p_StudentId
    AND PaymentTarget = 'TermFee'
    AND (p_SessionId IS NULL OR SessionId = p_SessionId OR SessionId IS NULL);

  SELECT IFNULL(Amount, 0) INTO v_Concession
  FROM StudentConcession
  WHERE OrganizationId = p_OrganizationId
    AND StudentId = p_StudentId
    AND IsDeleted = 0
    AND IFNULL(IsActive, 1) = 1
  LIMIT 1;

  SET v_YearlyNet = GREATEST(IFNULL(v_YearlyTotal, 0) - IFNULL(v_Concession, 0), 0);
  SET v_TermLeft = GREATEST(v_YearlyNet - IFNULL(v_TermPaid, 0), 0);

  IF v_YearlyNet <= 0 OR v_RemainTotal <= 0 OR v_TermLeft <= 0 THEN
    SELECT 0 AS SuccessFlag, 'No fee structure / remaining balance for this student.' AS Message, NULL AS PaymentId, NULL AS ReceiptNo, 0 AS Allocated, 0 AS Unallocated;
    LEAVE proc_label;
  END IF;
  IF p_TotalPaidAmount > v_TermLeft THEN
    SELECT 0 AS SuccessFlag, 'Amount exceeds term fee left.' AS Message, NULL AS PaymentId, NULL AS ReceiptNo, 0 AS Allocated, 0 AS Unallocated;
    LEAVE proc_label;
  END IF;

  INSERT INTO ReceiptSequence (OrganizationId, LastNumber)
  VALUES (p_OrganizationId, 1)
  ON DUPLICATE KEY UPDATE LastNumber = LastNumber + 1, ModifiedOn = NOW();
  SELECT LastNumber INTO @seq FROM ReceiptSequence WHERE OrganizationId = p_OrganizationId;
  SET v_ReceiptNo = CONCAT('RCPT-', DATE_FORMAT(p_PaymentDate,'%Y%m'), '-', LPAD(@seq,6,'0'));

  INSERT INTO FeePayment
    (OrganizationId, StudentId, PaymentTarget, SessionId, ReceiptNo, PaymentDate, PaymentMode, ReferenceNo, Notes, TotalPaidAmount, CreatedBy)
  VALUES
    (p_OrganizationId, p_StudentId, 'TermFee', p_SessionId, v_ReceiptNo, p_PaymentDate, p_PaymentMode, p_ReferenceNo, p_Notes, p_TotalPaidAmount, p_CreatedBy);
  SET v_PaymentId = LAST_INSERT_ID();

  INSERT INTO FeePaymentAllocation
    (OrganizationId, PaymentId, InvoiceId, InvoiceItemId, ClassFeeId, FeeTypeId, TermId, OldFeeId, AllocatedAmount)
  SELECT
    p_OrganizationId,
    v_PaymentId,
    NULL, NULL,
    t.ClassFeeId,
    t.FeeTypeId,
    t.TermId,
    NULL,
    LEAST(t.LineRemain, ROUND(p_TotalPaidAmount * (t.LineRemain / v_RemainTotal), 2))
  FROM tmp_fee_lines t
  WHERE t.LineRemain > 0
  ORDER BY t.DueDate IS NULL, t.DueDate ASC, t.ClassFeeId ASC;

  SELECT IFNULL(SUM(AllocatedAmount),0) INTO v_AllocatedSum
  FROM FeePaymentAllocation WHERE PaymentId = v_PaymentId;

  IF p_TotalPaidAmount - v_AllocatedSum > 0 THEN
    SELECT ClassFeeId, FeeTypeId, TermId INTO v_LastClassFeeId, v_LastFeeTypeId, v_LastTermId
    FROM tmp_fee_lines WHERE LineRemain > 0
    ORDER BY DueDate IS NULL, DueDate ASC, ClassFeeId ASC LIMIT 1;

    IF v_LastClassFeeId IS NOT NULL THEN
      UPDATE FeePaymentAllocation
      SET AllocatedAmount = AllocatedAmount + (p_TotalPaidAmount - v_AllocatedSum)
      WHERE PaymentId = v_PaymentId AND ClassFeeId = v_LastClassFeeId
      LIMIT 1;
    END IF;
  END IF;

  DROP TEMPORARY TABLE IF EXISTS tmp_fee_lines;

  SELECT 1 AS SuccessFlag, 'Term fee payment recorded.' AS Message, v_PaymentId AS PaymentId, v_ReceiptNo AS ReceiptNo,
         p_TotalPaidAmount AS Allocated, 0 AS Unallocated;
END$$

DELIMITER ;
