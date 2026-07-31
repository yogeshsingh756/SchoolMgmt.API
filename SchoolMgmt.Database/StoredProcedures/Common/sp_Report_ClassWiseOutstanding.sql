-- Procedure: sp_Report_ClassWiseOutstanding
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Report_ClassWiseOutstanding`;

DELIMITER $$

CREATE PROCEDURE `sp_Report_ClassWiseOutstanding` (IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_TermId` INT, IN `p_SessionId` INT)   BEGIN
  SELECT
    s.CurrentClassId AS ClassId,
    IFNULL(c.ClassName,'-') AS ClassName,
    COUNT(DISTINCT inv.InvoiceId) AS InvoiceCount,
    SUM(ii.NetAmount) AS GrossAmount,
    SUM(ii.PaidAmount) AS PaidAmount,
    SUM(ii.NetAmount - ii.PaidAmount) AS OutstandingAmount
  FROM StudentFeeInvoice inv
  INNER JOIN StudentFeeInvoiceItem ii ON ii.InvoiceId = inv.InvoiceId
  INNER JOIN Students s ON s.StudentId = inv.StudentId
  LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId
  WHERE inv.OrganizationId = p_OrganizationId
    AND inv.IsDeleted = 0
    AND ii.IsDeleted = 0
    AND (p_ClassId IS NULL OR p_ClassId = 0 OR s.CurrentClassId = p_ClassId)
    AND (p_TermId IS NULL OR p_TermId = 0 OR inv.TermId = p_TermId)
    AND (p_SessionId IS NULL OR p_SessionId = 0 OR inv.SessionId = p_SessionId)
  GROUP BY s.CurrentClassId
  ORDER BY OutstandingAmount DESC;
END$$

DELIMITER ;