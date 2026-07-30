-- Procedure: sp_Admin_Invoices_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Invoices_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Invoices_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100))   BEGIN
  DECLARE v_PageNumber INT DEFAULT 1;
  DECLARE v_PageSize INT DEFAULT 10;
  DECLARE v_Offset INT DEFAULT 0;

  SET v_PageNumber = IFNULL(p_PageNumber,1);
  SET v_PageSize   = IFNULL(p_PageSize,10);
  SET v_Offset     = (v_PageNumber - 1) * v_PageSize;

  SELECT SQL_CALC_FOUND_ROWS
         i.InvoiceId, i.InvoiceNo, i.StudentId,
         CONCAT(u.FirstName,' ',u.LastName) AS StudentName,
         i.InvoiceDate, i.DueDate,
         i.TotalAmount, i.TotalDiscount, i.NetPayable,
         i.PaidAmount, i.BalanceAmount, i.Status
  FROM StudentFeeInvoice i
  INNER JOIN Students s ON s.StudentId = i.StudentId
  INNER JOIN Users u ON u.UserId = s.UserId
  WHERE i.OrganizationId = p_OrganizationId
    AND i.IsDeleted = 0
    AND (p_Search IS NULL OR p_Search = '' 
         OR i.InvoiceNo LIKE CONCAT('%',p_Search,'%')
         OR u.FirstName LIKE CONCAT('%',p_Search,'%')
         OR u.LastName LIKE CONCAT('%',p_Search,'%'))
  ORDER BY i.InvoiceDate DESC, i.InvoiceId DESC
  LIMIT v_Offset, v_PageSize;

  SELECT FOUND_ROWS() AS TotalRows;
END$$

DELIMITER ;