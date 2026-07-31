-- Procedure: sp_Admin_TeacherSubjects_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_TeacherSubjects_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_TeacherSubjects_Delete` (IN `p_OrganizationId` INT, IN `p_TeacherSubjectId` INT, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE TeacherSubjects
  SET IsActive = 0, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
  WHERE TeacherSubjectId = p_TeacherSubjectId AND OrganizationId = p_OrganizationId;

  SELECT 1 AS SuccessFlag, 'TeacherSubject unassigned.' AS Message;
END$$

DELIMITER ;