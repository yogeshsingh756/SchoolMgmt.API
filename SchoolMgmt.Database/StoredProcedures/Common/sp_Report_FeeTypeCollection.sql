-- Procedure: sp_Report_FeeTypeCollection
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Report_FeeTypeCollection`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Report_FeeTypeCollection` (IN `p_OrganizationId` INT, IN `p_FromDate` DATE, IN `p_ToDate` DATE, IN `p_TermId` INT, IN `p_SessionId` INT)   BEGIN
  SELECT
    ft.FeeTypeId,
    ft.FeeTypeName,
    IFNULL(SUM(ii.Amount),0) AS InvoicedAmount,
    IFNULL(SUM(fa.AllocatedAmount),0) AS CollectedAmount,
    IFNULL(SUM(ii.NetAmount - ii.PaidAmount),0) AS OutstandingAmount
  FROM FeeTypes ft
  LEFT JOIN StudentFeeInvoiceItem ii ON ii.FeeTypeId = ft.FeeTypeId AND ii.IsDeleted = 0
  LEFT JOIN StudentFeeInvoice inv ON inv.InvoiceId = ii.InvoiceId AND inv.IsDeleted = 0
  LEFT JOIN FeePaymentAllocation fa ON fa.InvoiceItemId = ii.InvoiceItemId
  WHERE ft.OrganizationId = p_OrganizationId
    AND (p_TermId IS NULL OR p_TermId = 0 OR inv.TermId = p_TermId)
    AND (p_SessionId IS NULL OR p_SessionId = 0 OR inv.SessionId = p_SessionId)
    AND (p_FromDate IS NULL OR DATE(inv.InvoiceDate) >= p_FromDate)
    AND (p_ToDate IS NULL OR DATE(inv.InvoiceDate) <= p_ToDate)
  GROUP BY ft.FeeTypeId, ft.FeeTypeName
  ORDER BY CollectedAmount DESC;
END$$

DELIMITER ;