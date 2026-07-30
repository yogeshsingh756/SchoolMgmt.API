-- Procedure: sp_Admin_Subjects_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Subjects_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Subjects_Create` (IN `p_OrganizationId` INT, IN `p_SubjectName` VARCHAR(150), IN `p_SubjectCode` VARCHAR(50), IN `p_Description` VARCHAR(500), IN `p_CreatedBy` INT)   BEGIN
  DECLARE v_exists INT DEFAULT 0;
  SELECT COUNT(*) INTO v_exists FROM Subjects WHERE OrganizationId = p_OrganizationId AND SubjectName = p_SubjectName AND IsDeleted = 0;
  IF v_exists > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Subject already exists for this organization.';
  END IF;

  INSERT INTO Subjects (OrganizationId, SubjectName, SubjectCode, Description, IsActive, IsDeleted, CreatedOn, CreatedBy)
  VALUES (p_OrganizationId, p_SubjectName, p_SubjectCode, p_Description, 1, 0, NOW(), p_CreatedBy);

  SELECT LAST_INSERT_ID() AS SubjectId, 'Subject created successfully.' AS Message;
END$$

DELIMITER ;