-- Procedure: sp_Report_StudentOutstanding
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Report_StudentOutstanding`;

DELIMITER $$

CREATE PROCEDURE `sp_Report_StudentOutstanding` (IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_Search` VARCHAR(100), IN `p_PageNumber` INT, IN `p_PageSize` INT)   BEGIN
  DECLARE v_offset INT DEFAULT 0;

  SET p_PageNumber = IFNULL(p_PageNumber, 1);
  SET p_PageSize = IFNULL(p_PageSize, 20);

  SET v_offset = (p_PageNumber - 1) * p_PageSize;

  SELECT SQL_CALC_FOUND_ROWS
    s.StudentId,
    u.UserId,
    CONCAT(u.FirstName, ' ', u.LastName) AS StudentName,
    s.AdmissionNo,
    s.CurrentClassId,
    SUM(ii.NetAmount) AS TotalInvoiced,
    SUM(ii.PaidAmount) AS TotalPaid,
    SUM(ii.NetAmount - ii.PaidAmount) AS Outstanding
  FROM Students s
    INNER JOIN Users u ON u.UserId = s.UserId
    LEFT JOIN StudentFeeInvoice inv ON inv.StudentId = s.StudentId AND inv.IsDeleted = 0
    LEFT JOIN StudentFeeInvoiceItem ii ON ii.InvoiceId = inv.InvoiceId AND ii.IsDeleted = 0
  WHERE s.OrganizationId = p_OrganizationId
    AND s.IsDeleted = 0
    AND (p_ClassId IS NULL OR p_ClassId = 0 OR s.CurrentClassId = p_ClassId)
    AND (p_Search IS NULL OR p_Search = '' 
         OR u.FirstName LIKE CONCAT('%', p_Search, '%')
         OR u.LastName LIKE CONCAT('%', p_Search, '%')
         OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%'))
  GROUP BY s.StudentId
  ORDER BY Outstanding DESC
  LIMIT v_offset, p_PageSize;

  SELECT FOUND_ROWS() AS TotalRecords;
END$$

DELIMITER ;