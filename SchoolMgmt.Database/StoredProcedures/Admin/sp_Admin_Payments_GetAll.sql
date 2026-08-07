-- Procedure: sp_Admin_Payments_GetAll
-- FeePayment.StudentId stores Users.UserId (not Students.StudentId)

DROP PROCEDURE IF EXISTS `sp_Admin_Payments_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Payments_GetAll` (
  IN `p_OrganizationId` INT,
  IN `p_PageNumber` INT,
  IN `p_PageSize` INT,
  IN `p_Search` VARCHAR(100),
  IN `p_ClassId` INT,
  IN `p_SectionId` INT,
  IN `p_PaymentMode` VARCHAR(50),
  IN `p_FromDate` DATE,
  IN `p_ToDate` DATE
)
BEGIN
  DECLARE v_PageNumber INT DEFAULT 1;
  DECLARE v_PageSize INT DEFAULT 10;
  DECLARE v_Offset INT DEFAULT 0;

  SET v_PageNumber = IFNULL(NULLIF(p_PageNumber, 0), 1);
  SET v_PageSize   = IFNULL(NULLIF(p_PageSize, 0), 10);
  SET v_Offset     = (v_PageNumber - 1) * v_PageSize;
  SET p_ClassId    = NULLIF(p_ClassId, 0);
  SET p_SectionId  = NULLIF(p_SectionId, 0);
  SET p_Search     = NULLIF(TRIM(IFNULL(p_Search, '')), '');
  SET p_PaymentMode = NULLIF(TRIM(IFNULL(p_PaymentMode, '')), '');

  SELECT SQL_CALC_FOUND_ROWS
         p.PaymentId,
         p.ReceiptNo,
         p.StudentId,
         p.PaymentTarget,
         p.SessionId,
         CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS StudentName,
         s.AdmissionNo,
         s.CurrentClassId,
         s.CurrentSectionId,
         c.ClassName,
         sec.SectionName,
         p.PaymentDate,
         p.PaymentMode,
         p.ReferenceNo,
         p.Notes,
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
  INNER JOIN Users u ON u.UserId = p.StudentId
  LEFT JOIN Students s
    ON s.UserId = p.StudentId
   AND s.OrganizationId = p.OrganizationId
   AND IFNULL(s.IsDeleted, 0) = 0
  LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId AND IFNULL(c.IsDeleted, 0) = 0
  LEFT JOIN Sections sec ON sec.SectionId = s.CurrentSectionId
  WHERE p.OrganizationId = p_OrganizationId
    AND (
      p_Search IS NULL
      OR p.ReceiptNo LIKE CONCAT('%', p_Search, '%')
      OR u.FirstName LIKE CONCAT('%', p_Search, '%')
      OR u.LastName LIKE CONCAT('%', p_Search, '%')
      OR CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) LIKE CONCAT('%', p_Search, '%')
      OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%')
      OR p.ReferenceNo LIKE CONCAT('%', p_Search, '%')
    )
    AND (p_ClassId IS NULL OR s.CurrentClassId = p_ClassId)
    AND (p_SectionId IS NULL OR s.CurrentSectionId = p_SectionId)
    AND (p_PaymentMode IS NULL OR p.PaymentMode = p_PaymentMode)
    AND (p_FromDate IS NULL OR DATE(p.PaymentDate) >= p_FromDate)
    AND (p_ToDate IS NULL OR DATE(p.PaymentDate) <= p_ToDate)
  ORDER BY p.PaymentId DESC
  LIMIT v_Offset, v_PageSize;

  SELECT FOUND_ROWS() AS TotalRows;
END$$

DELIMITER ;
