-- Procedure: sp_Admin_ClassSubjects_GetByClass
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_ClassSubjects_GetByClass`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_ClassSubjects_GetByClass` (IN `p_OrganizationId` INT, IN `p_ClassId` INT)   BEGIN
  SELECT cs.ClassSubjectId, cs.ClassId, cs.SubjectId, s.SubjectName, s.SubjectCode, cs.IsActive, cs.CreatedOn
  FROM ClassSubjects cs
  JOIN Subjects s ON cs.SubjectId = s.SubjectId
  WHERE cs.OrganizationId = p_OrganizationId AND cs.ClassId = p_ClassId AND s.IsDeleted = 0 And cs.IsActive = 1;
END$$

DELIMITER ;