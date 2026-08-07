-- Procedure: sp_Admin_StudentConcession_GetByStudent

DROP PROCEDURE IF EXISTS `sp_Admin_StudentConcession_GetByStudent`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_StudentConcession_GetByStudent` (
  IN `p_OrganizationId` INT,
  IN `p_StudentId` INT
)
BEGIN
  SELECT
    ConcessionId, OrganizationId, StudentId, SessionId,
    Amount, Notes, IsActive, CreatedOn, ModifiedOn
  FROM StudentConcession
  WHERE OrganizationId = p_OrganizationId
    AND StudentId = p_StudentId
    AND IsDeleted = 0
  LIMIT 1;
END$$

DELIMITER ;
