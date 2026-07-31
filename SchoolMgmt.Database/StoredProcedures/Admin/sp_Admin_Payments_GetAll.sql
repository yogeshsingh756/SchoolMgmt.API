-- Procedure: sp_Admin_Payments_GetAll
-- Deploy note: Deploy this SP together with the API that passes the new optional filter params.
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Payments_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Payments_GetAll` (
  IN `p_OrganizationId` INT,
  IN `p_PageNumber` INT,
  IN `p_PageSize` INT,
  IN `p_Search` VARCHAR(100),
  IN `p_ClassId` INT,
  IN `p_PaymentMode` VARCHAR(50),
  IN `p_FromDate` DATE,
  IN `p_ToDate` DATE
)
BEGIN
  DECLARE v_PageNumber INT DEFAULT 1;
  DECLARE v_PageSize INT DEFAULT 10;
  DECLARE v_Offset INT DEFAULT 0;

  SET v_PageNumber = IFNULL(p_PageNumber, 1);
  SET v_PageSize   = IFNULL(p_PageSize, 10);
  SET v_Offset     = (v_PageNumber - 1) * v_PageSize;

  SELECT SQL_CALC_FOUND_ROWS
         p.PaymentId, p.ReceiptNo, p.StudentId,
         CONCAT(u.FirstName, ' ', u.LastName) AS StudentName,
         s.AdmissionNo,
         s.CurrentClassId,
         TRIM(CONCAT(
           IFNULL(c.ClassName, ''),
           IF(c.Section IS NULL OR c.Section = '', '', CONCAT(' - ', c.Section))
         )) AS ClassName,
         p.PaymentDate, p.PaymentMode, p.ReferenceNo,
         p.TotalPaidAmount,
         (
           SELECT IFNULL(SUM(a.AllocatedAmount), 0)
           FROM FeePaymentAllocation a
           WHERE a.PaymentId = p.PaymentId
         ) AS AllocatedAmount,
         (
           p.TotalPaidAmount -
           (
             SELECT IFNULL(SUM(a.AllocatedAmount), 0)
             FROM FeePaymentAllocation a
             WHERE a.PaymentId = p.PaymentId
           )
         ) AS UnAllocatedAmount
  FROM FeePayment p
  INNER JOIN Students s ON s.StudentId = p.StudentId
  INNER JOIN Users u ON u.UserId = s.UserId
  LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId AND c.IsDeleted = 0
  WHERE p.OrganizationId = p_OrganizationId
    AND (p_Search IS NULL OR p_Search = ''
         OR p.ReceiptNo LIKE CONCAT('%', p_Search, '%')
         OR u.FirstName LIKE CONCAT('%', p_Search, '%')
         OR u.LastName LIKE CONCAT('%', p_Search, '%')
         OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%')
         OR p.ReferenceNo LIKE CONCAT('%', p_Search, '%'))
    AND (p_ClassId IS NULL OR p_ClassId = 0 OR s.CurrentClassId = p_ClassId)
    AND (p_PaymentMode IS NULL OR p_PaymentMode = '' OR p.PaymentMode = p_PaymentMode)
    AND (p_FromDate IS NULL OR p.PaymentDate >= p_FromDate)
    AND (p_ToDate IS NULL OR p.PaymentDate <= p_ToDate)
  ORDER BY p.PaymentDate DESC, p.PaymentId DESC
  LIMIT v_Offset, v_PageSize;

  SELECT FOUND_ROWS() AS TotalRows;
END$$

DELIMITER ;
