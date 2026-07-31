-- Procedure: sp_Admin_Subjects_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Subjects_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Subjects_Delete` (IN `p_OrganizationId` INT, IN `p_SubjectId` INT, IN `p_ModifiedBy` INT)   BEGIN
  DECLARE v_exists INT DEFAULT 0;
  SELECT COUNT(*) INTO v_exists FROM Subjects WHERE OrganizationId = p_OrganizationId AND SubjectId = p_SubjectId AND IsDeleted = 0;
  IF v_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid SubjectId or does not belong to organization.';
  END IF;

  UPDATE Subjects
  SET IsDeleted = 1, IsActive = 0, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
  WHERE SubjectId = p_SubjectId AND OrganizationId = p_OrganizationId;

  SELECT 1 AS SuccessFlag, 'Subject deleted (soft) successfully.' AS Message;
END$$

DELIMITER ;