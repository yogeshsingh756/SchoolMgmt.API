-- Procedure: sp_Admin_Subjects_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Subjects_Update`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Subjects_Update` (IN `p_OrganizationId` INT, IN `p_SubjectId` INT, IN `p_SubjectName` VARCHAR(150), IN `p_SubjectCode` VARCHAR(50), IN `p_Description` VARCHAR(500), IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
  DECLARE v_exists INT DEFAULT 0;
  SELECT COUNT(*) INTO v_exists FROM Subjects WHERE OrganizationId = p_OrganizationId AND SubjectId = p_SubjectId AND IsDeleted = 0;
  IF v_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid SubjectId or does not belong to organization.';
  END IF;

  UPDATE Subjects
  SET SubjectName = p_SubjectName,
      SubjectCode = p_SubjectCode,
      Description = p_Description,
      IsActive = IFNULL(p_IsActive,1),
      ModifiedBy = p_ModifiedBy,
      ModifiedOn = NOW()
  WHERE SubjectId = p_SubjectId AND OrganizationId = p_OrganizationId;

  SELECT 1 AS SuccessFlag, 'Subject updated successfully.' AS Message;
END$$

DELIMITER ;