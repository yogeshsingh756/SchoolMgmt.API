-- Procedure: sp_Admin_Payment_GetById (receipt print)
-- Line amounts stay at configured ClassFeeMaster / OldFee totals (gross).
-- ConcessionAmount is returned on header for receipt total display.

DROP PROCEDURE IF EXISTS `sp_Admin_Payment_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Payment_GetById` (
  IN `p_OrganizationId` INT,
  IN `p_PaymentId` INT
)
BEGIN
  DECLARE v_StudentId INT;
  DECLARE v_PaymentId INT;
  DECLARE v_Concession DECIMAL(10,2) DEFAULT 0;

  SET v_PaymentId = p_PaymentId;

  SELECT p.StudentId INTO v_StudentId
  FROM FeePayment p
  WHERE p.OrganizationId = p_OrganizationId AND p.PaymentId = v_PaymentId
  LIMIT 1;

  SELECT IFNULL(Amount, 0) INTO v_Concession
  FROM StudentConcession
  WHERE OrganizationId = p_OrganizationId
    AND StudentId = v_StudentId
    AND IsDeleted = 0
    AND IFNULL(IsActive, 1) = 1
  LIMIT 1;

  SELECT
    p.PaymentId, p.StudentId, p.PaymentTarget, p.SessionId,
    p.ReceiptNo, p.PaymentDate, p.PaymentMode, p.ReferenceNo, p.Notes, p.TotalPaidAmount,
    CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS StudentName,
    u.Email AS Email,
    u.Phone AS Phone,
    s.AdmissionNo, c.ClassName, sec.SectionName, sess.SessionName,
    IFNULL(v_Concession, 0) AS ConcessionAmount
  FROM FeePayment p
  INNER JOIN Users u ON u.UserId = p.StudentId
  LEFT JOIN Students s ON s.UserId = p.StudentId AND s.OrganizationId = p.OrganizationId
  LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId
  LEFT JOIN Sections sec ON sec.SectionId = s.CurrentSectionId
  LEFT JOIN AcademicSessions sess ON sess.SessionId = p.SessionId
  WHERE p.OrganizationId = p_OrganizationId AND p.PaymentId = v_PaymentId
  LIMIT 1;

  SELECT
    a.AllocationId,
    a.ClassFeeId,
    a.FeeTypeId,
    a.TermId,
    a.OldFeeId,
    a.AllocatedAmount,
    ft.FeeTypeName,
    t.TermName,
    CASE
      WHEN a.OldFeeId IS NOT NULL THEN IFNULL(ofee.TotalAmount, 0)
      ELSE IFNULL(cfm.Amount, 0)
    END AS ConfiguredAmount,
    a.AllocatedAmount AS PaidAmount,
    GREATEST(
      CASE
        WHEN a.OldFeeId IS NOT NULL THEN IFNULL(ofee.TotalAmount, 0)
        ELSE IFNULL(cfm.Amount, 0)
      END
      - CASE
        WHEN a.OldFeeId IS NOT NULL THEN IFNULL((
          SELECT SUM(a2.AllocatedAmount)
          FROM FeePaymentAllocation a2
          INNER JOIN FeePayment p2 ON p2.PaymentId = a2.PaymentId
          WHERE a2.OrganizationId = p_OrganizationId
            AND a2.OldFeeId = a.OldFeeId
            AND p2.StudentId = v_StudentId
            AND p2.PaymentId <= v_PaymentId
        ), 0)
        ELSE IFNULL((
          SELECT SUM(a2.AllocatedAmount)
          FROM FeePaymentAllocation a2
          INNER JOIN FeePayment p2 ON p2.PaymentId = a2.PaymentId
          WHERE a2.OrganizationId = p_OrganizationId
            AND a2.ClassFeeId = a.ClassFeeId
            AND p2.StudentId = v_StudentId
            AND p2.PaymentTarget = 'TermFee'
            AND p2.PaymentId <= v_PaymentId
        ), 0)
      END
    , 0) AS BalanceAmount
  FROM FeePaymentAllocation a
  LEFT JOIN FeeTypes ft ON ft.FeeTypeId = a.FeeTypeId
  LEFT JOIN AcademicTerms t ON t.TermId = a.TermId
  LEFT JOIN ClassFeeMaster cfm ON cfm.ClassFeeId = a.ClassFeeId
  LEFT JOIN StudentOldFee ofee ON ofee.OldFeeId = a.OldFeeId
  WHERE a.OrganizationId = p_OrganizationId AND a.PaymentId = v_PaymentId
  ORDER BY a.AllocationId;
END$$

DELIMITER ;
