-- Procedure: sp_Admin_Payments_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Payments_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Payments_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100))   BEGIN
  DECLARE v_PageNumber INT DEFAULT 1;
  DECLARE v_PageSize INT DEFAULT 10;
  DECLARE v_Offset INT DEFAULT 0;

  SET v_PageNumber = IFNULL(p_PageNumber,1);
  SET v_PageSize   = IFNULL(p_PageSize,10);
  SET v_Offset     = (v_PageNumber - 1) * v_PageSize;

  SELECT SQL_CALC_FOUND_ROWS
         p.PaymentId, p.ReceiptNo, p.StudentId,
         CONCAT(u.FirstName,' ',u.LastName) AS StudentName,
         p.PaymentDate, p.PaymentMode, p.ReferenceNo,
         p.TotalPaidAmount,
      (
    SELECT IFNULL(SUM(a.AllocatedAmount),0)
    FROM FeePaymentAllocation a
    WHERE a.PaymentId = p.PaymentId
) AS AllocatedAmount,

(
    p.TotalPaidAmount - 
    (
        SELECT IFNULL(SUM(a.AllocatedAmount),0)
        FROM FeePaymentAllocation a
        WHERE a.PaymentId = p.PaymentId
    )
) AS UnAllocatedAmount

  FROM FeePayment p
  INNER JOIN Students s ON s.StudentId = p.StudentId
  INNER JOIN Users u ON u.UserId = s.UserId
  
  WHERE p.OrganizationId = p_OrganizationId
    AND (p_Search IS NULL OR p_Search = ''
         OR p.ReceiptNo LIKE CONCAT('%',p_Search,'%')
         OR u.FirstName LIKE CONCAT('%',p_Search,'%')
         OR u.LastName LIKE CONCAT('%',p_Search,'%'))
         
  ORDER BY p.PaymentDate DESC, p.PaymentId DESC
  LIMIT v_Offset, v_PageSize;

  SELECT FOUND_ROWS() AS TotalRows;
END$$

DELIMITER ;