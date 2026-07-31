-- Procedure: sp_Report_StudentLedger
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Report_StudentLedger`;

DELIMITER $$

CREATE PROCEDURE `sp_Report_StudentLedger` (IN `p_OrganizationId` INT, IN `p_StudentId` INT, IN `p_FromDate` DATE, IN `p_ToDate` DATE)   BEGIN
  -- Invoices (debit)
  SELECT
    inv.InvoiceDate AS TxnDate,
    CONCAT('Invoice: ', inv.InvoiceNo) AS Description,
    ii.InvoiceId,
    ii.InvoiceItemId,
    ii.FeeTypeId,
    ft.FeeTypeName,
    ii.NetAmount AS Debit,
    0.00 AS Credit,
    inv.InvoiceId AS SortKey
  FROM StudentFeeInvoice inv
  INNER JOIN StudentFeeInvoiceItem ii ON ii.InvoiceId = inv.InvoiceId AND ii.IsDeleted = 0
  LEFT JOIN FeeTypes ft ON ft.FeeTypeId = ii.FeeTypeId
  WHERE inv.OrganizationId = p_OrganizationId
    AND inv.StudentId = p_StudentId
    AND (p_FromDate IS NULL OR DATE(inv.InvoiceDate) >= p_FromDate)
    AND (p_ToDate IS NULL OR DATE(inv.InvoiceDate) <= p_ToDate)

  UNION ALL

  -- Payments (credit) via allocations
  SELECT
    fp.PaymentDate AS TxnDate,
    CONCAT('Payment: ', fp.ReceiptNo) AS Description,
    fa.InvoiceId,
    fa.InvoiceItemId,
    ii.FeeTypeId,
    ft.FeeTypeName,
    0.00 AS Debit,
    fa.AllocatedAmount AS Credit,
    fp.PaymentId * -1 AS SortKey
  FROM FeePaymentAllocation fa
  INNER JOIN FeePayment fp ON fp.PaymentId = fa.PaymentId
  INNER JOIN StudentFeeInvoiceItem ii ON ii.InvoiceItemId = fa.InvoiceItemId
  LEFT JOIN FeeTypes ft ON ft.FeeTypeId = ii.FeeTypeId
  WHERE fa.OrganizationId = p_OrganizationId
    AND ii.InvoiceId IN (SELECT InvoiceId FROM StudentFeeInvoice WHERE StudentId = p_StudentId AND OrganizationId = p_OrganizationId)
    AND (p_FromDate IS NULL OR DATE(fp.PaymentDate) >= p_FromDate)
    AND (p_ToDate IS NULL OR DATE(fp.PaymentDate) <= p_ToDate)

  ORDER BY TxnDate, SortKey;
END$$

DELIMITER ;