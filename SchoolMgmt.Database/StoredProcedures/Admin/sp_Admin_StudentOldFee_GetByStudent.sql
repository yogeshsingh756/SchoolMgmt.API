-- Procedure: sp_Admin_StudentOldFee_GetByStudent

DROP PROCEDURE IF EXISTS `sp_Admin_StudentOldFee_GetByStudent`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_StudentOldFee_GetByStudent` (
  IN `p_OrganizationId` INT,
  IN `p_StudentId` INT
)
BEGIN
  SELECT
    OldFeeId, OrganizationId, StudentId, SessionId,
    TotalAmount, PaidAmount,
    GREATEST(TotalAmount - PaidAmount, 0) AS LeftAmount,
    Notes, IsActive, CreatedOn, ModifiedOn
  FROM StudentOldFee
  WHERE OrganizationId = p_OrganizationId
    AND StudentId = p_StudentId
    AND IsDeleted = 0
  LIMIT 1;
END$$

DELIMITER ;
