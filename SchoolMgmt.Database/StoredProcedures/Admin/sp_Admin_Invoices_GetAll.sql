-- Procedure: sp_Admin_Invoices_GetAll
-- Deploy note: Deploy this SP together with the API that passes the new optional filter params.
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Invoices_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Invoices_GetAll` (
  IN `p_OrganizationId` INT,
  IN `p_PageNumber` INT,
  IN `p_PageSize` INT,
  IN `p_Search` VARCHAR(100),
  IN `p_ClassId` INT,
  IN `p_Status` VARCHAR(50),
  IN `p_FromDate` DATE,
  IN `p_ToDate` DATE,
  IN `p_TermId` INT,
  IN `p_SessionId` INT
)
BEGIN
  DECLARE v_PageNumber INT DEFAULT 1;
  DECLARE v_PageSize INT DEFAULT 10;
  DECLARE v_Offset INT DEFAULT 0;

  SET v_PageNumber = IFNULL(p_PageNumber, 1);
  SET v_PageSize   = IFNULL(p_PageSize, 10);
  SET v_Offset     = (v_PageNumber - 1) * v_PageSize;

  SELECT SQL_CALC_FOUND_ROWS
         i.InvoiceId, i.InvoiceNo, i.StudentId,
         CONCAT(u.FirstName, ' ', u.LastName) AS StudentName,
         s.AdmissionNo,
         s.CurrentClassId,
         TRIM(CONCAT(
           IFNULL(c.ClassName, ''),
           IF(c.Section IS NULL OR c.Section = '', '', CONCAT(' - ', c.Section))
         )) AS ClassName,
         i.InvoiceDate, i.DueDate,
         i.TotalAmount, i.TotalDiscount, i.NetPayable,
         i.PaidAmount, i.BalanceAmount, i.Status,
         i.TermId, i.SessionId
  FROM StudentFeeInvoice i
  INNER JOIN Students s ON s.StudentId = i.StudentId
  INNER JOIN Users u ON u.UserId = s.UserId
  LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId AND c.IsDeleted = 0
  WHERE i.OrganizationId = p_OrganizationId
    AND i.IsDeleted = 0
    AND (p_Search IS NULL OR p_Search = ''
         OR i.InvoiceNo LIKE CONCAT('%', p_Search, '%')
         OR u.FirstName LIKE CONCAT('%', p_Search, '%')
         OR u.LastName LIKE CONCAT('%', p_Search, '%')
         OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%'))
    AND (p_ClassId IS NULL OR p_ClassId = 0 OR s.CurrentClassId = p_ClassId)
    AND (p_Status IS NULL OR p_Status = '' OR i.Status = p_Status)
    AND (p_FromDate IS NULL OR i.InvoiceDate >= p_FromDate)
    AND (p_ToDate IS NULL OR i.InvoiceDate <= p_ToDate)
    AND (p_TermId IS NULL OR p_TermId = 0 OR i.TermId = p_TermId)
    AND (p_SessionId IS NULL OR p_SessionId = 0 OR i.SessionId = p_SessionId)
  ORDER BY i.InvoiceDate DESC, i.InvoiceId DESC
  LIMIT v_Offset, v_PageSize;

  SELECT FOUND_ROWS() AS TotalRows;
END$$

DELIMITER ;
