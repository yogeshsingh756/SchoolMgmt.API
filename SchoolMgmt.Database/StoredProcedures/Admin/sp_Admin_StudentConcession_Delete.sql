-- Procedure: sp_Admin_StudentConcession_Delete

DROP PROCEDURE IF EXISTS `sp_Admin_StudentConcession_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_StudentConcession_Delete` (
  IN `p_OrganizationId` INT,
  IN `p_ConcessionId` INT,
  IN `p_ModifiedBy` INT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM StudentConcession
    WHERE ConcessionId = p_ConcessionId AND OrganizationId = p_OrganizationId AND IsDeleted = 0
  ) THEN
    SELECT 0 AS SuccessFlag, 'Concession not found.' AS Message;
  ELSE
    UPDATE StudentConcession
    SET IsDeleted = 1, IsActive = 0, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
    WHERE ConcessionId = p_ConcessionId AND OrganizationId = p_OrganizationId;
    SELECT 1 AS SuccessFlag, 'Concession removed.' AS Message;
  END IF;
END$$

DELIMITER ;
