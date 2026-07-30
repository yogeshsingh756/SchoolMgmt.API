-- Procedure: sp_Admin_Invoices_GenerateForStudent
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Invoices_GenerateForStudent`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Invoices_GenerateForStudent` (IN `p_OrganizationId` INT, IN `p_StudentId` INT, IN `p_ClassId` INT, IN `p_TermId` INT, IN `p_SessionId` INT, IN `p_InvoiceDate` DATE, IN `p_DueDate` DATE, IN `p_Notes` VARCHAR(255), IN `p_CreatedBy` INT)   BEGIN
  DECLARE v_InvoiceId INT;
  DECLARE v_InvoiceNo VARCHAR(50);
  DECLARE v_Total DECIMAL(10,2) DEFAULT 0;
  DECLARE v_Discount DECIMAL(10,2) DEFAULT 0;

  SET v_InvoiceNo = CONCAT(DATE_FORMAT(p_InvoiceDate,'%Y%m'), LPAD(FLOOR(RAND()*90000)+10000,5,'0'));

  INSERT INTO StudentFeeInvoice
    (OrganizationId, StudentId, InvoiceNo, TermId, SessionId, InvoiceDate, DueDate, Notes, CreatedBy)
  VALUES
    (p_OrganizationId, p_StudentId, v_InvoiceNo, p_TermId, p_SessionId, p_InvoiceDate, p_DueDate, p_Notes, p_CreatedBy);

  SET v_InvoiceId = LAST_INSERT_ID();

  INSERT INTO StudentFeeInvoiceItem
    (OrganizationId, InvoiceId, FeeTypeId, Amount, DiscountAmount, NetAmount)
  SELECT
    cfm.OrganizationId, v_InvoiceId, cfm.FeeTypeId, cfm.Amount,
    CASE 
      WHEN sc.ConcessionId IS NULL THEN 0
      WHEN sc.DiscountType = 'Flat' THEN LEAST(sc.DiscountValue, cfm.Amount)
      WHEN sc.DiscountType = 'Percent' THEN ROUND(LEAST(100, GREATEST(0, sc.DiscountValue)) * cfm.Amount / 100, 2)
      ELSE 0
    END AS DiscountAmount,
    cfm.Amount - 
    CASE 
      WHEN sc.ConcessionId IS NULL THEN 0
      WHEN sc.DiscountType = 'Flat' THEN LEAST(sc.DiscountValue, cfm.Amount)
      WHEN sc.DiscountType = 'Percent' THEN ROUND(LEAST(100, GREATEST(0, sc.DiscountValue)) * cfm.Amount / 100, 2)
      ELSE 0
    END AS NetAmount
  FROM ClassFeeMaster cfm
  LEFT JOIN StudentFeeConcessions sc
    ON sc.OrganizationId = cfm.OrganizationId
   AND sc.StudentId = p_StudentId
   AND sc.FeeTypeId = cfm.FeeTypeId
   AND sc.IsDeleted = 0
   AND sc.IsActive = 1
  WHERE cfm.OrganizationId = p_OrganizationId
    AND cfm.ClassId = p_ClassId
    AND (cfm.TermId <=> p_TermId)
    AND (cfm.SessionId <=> p_SessionId)
    AND cfm.IsDeleted = 0
    AND cfm.IsActive = 1;

  SELECT IFNULL(SUM(Amount),0), IFNULL(SUM(DiscountAmount),0), IFNULL(SUM(NetAmount),0)
    INTO v_Total, v_Discount, @net
  FROM StudentFeeInvoiceItem
  WHERE OrganizationId = p_OrganizationId AND InvoiceId = v_InvoiceId AND IsDeleted = 0;

  UPDATE StudentFeeInvoice
     SET TotalAmount = v_Total,
         TotalDiscount = v_Discount,
         NetPayable = @net,
         BalanceAmount = @net,
         Status = CASE WHEN @net = 0 THEN 'Paid' ELSE 'Pending' END
   WHERE InvoiceId = v_InvoiceId;

  SELECT v_InvoiceId AS InvoiceId, v_InvoiceNo AS InvoiceNo;
END$$

DELIMITER ;