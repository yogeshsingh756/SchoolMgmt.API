-- Procedure: sp_Admin_Subjects_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Subjects_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Subjects_GetById` (IN `p_OrganizationId` INT, IN `p_SubjectId` INT)   BEGIN
  SELECT SubjectId, SubjectName, SubjectCode, Description, IsActive, CreatedOn, ModifiedOn
  FROM Subjects
  WHERE OrganizationId = p_OrganizationId AND SubjectId = p_SubjectId AND IsDeleted = 0
  LIMIT 1;
END$$

DELIMITER ;