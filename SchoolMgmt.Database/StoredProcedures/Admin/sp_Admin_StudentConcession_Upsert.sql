-- Procedure: sp_Admin_StudentConcession_Upsert

DROP PROCEDURE IF EXISTS `sp_Admin_StudentConcession_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_StudentConcession_Upsert` (
  IN `p_ConcessionId` INT,
  IN `p_OrganizationId` INT,
  IN `p_StudentId` INT,
  IN `p_SessionId` INT,
  IN `p_Amount` DECIMAL(10,2),
  IN `p_Notes` VARCHAR(255),
  IN `p_IsActive` TINYINT(1),
  IN `p_ModifiedBy` INT
)
BEGIN
  SET p_SessionId = NULLIF(p_SessionId, 0);

  IF IFNULL(p_Amount, 0) <= 0 THEN
    SELECT 0 AS ConcessionId, 0 AS SuccessFlag, 'Concession amount must be greater than zero.' AS Message;
  ELSEIF IFNULL(p_ConcessionId, 0) = 0 THEN
    IF EXISTS (
      SELECT 1 FROM StudentConcession
      WHERE OrganizationId = p_OrganizationId AND StudentId = p_StudentId AND IsDeleted = 0
    ) THEN
      SELECT 0 AS ConcessionId, 0 AS SuccessFlag, 'Concession already mapped for this student.' AS Message;
    ELSE
      INSERT INTO StudentConcession
        (OrganizationId, StudentId, SessionId, Amount, Notes, IsActive, CreatedBy, CreatedOn)
      VALUES
        (p_OrganizationId, p_StudentId, p_SessionId, p_Amount, p_Notes, IFNULL(p_IsActive,1), p_ModifiedBy, NOW());
      SELECT LAST_INSERT_ID() AS ConcessionId, 1 AS SuccessFlag, 'Concession mapped.' AS Message;
    END IF;
  ELSE
    IF NOT EXISTS (
      SELECT 1 FROM StudentConcession
      WHERE ConcessionId = p_ConcessionId AND OrganizationId = p_OrganizationId AND IsDeleted = 0
    ) THEN
      SELECT 0 AS ConcessionId, 0 AS SuccessFlag, 'Concession not found.' AS Message;
    ELSE
      UPDATE StudentConcession
      SET SessionId = p_SessionId,
          Amount = p_Amount,
          Notes = p_Notes,
          IsActive = IFNULL(p_IsActive, 1),
          ModifiedBy = p_ModifiedBy,
          ModifiedOn = NOW()
      WHERE ConcessionId = p_ConcessionId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;
      SELECT p_ConcessionId AS ConcessionId, 1 AS SuccessFlag, 'Concession updated.' AS Message;
    END IF;
  END IF;
END$$

DELIMITER ;
