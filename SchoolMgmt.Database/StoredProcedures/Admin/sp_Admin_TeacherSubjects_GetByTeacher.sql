-- Procedure: sp_Admin_TeacherSubjects_GetByTeacher
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_TeacherSubjects_GetByTeacher`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_TeacherSubjects_GetByTeacher` (IN `p_OrganizationId` INT, IN `p_TeacherId` INT)   BEGIN
  SELECT ts.TeacherSubjectId, ts.TeacherId, ts.ClassId, c.ClassName, ts.SectionId, s.SectionName, ts.SubjectId, sub.SubjectName, ts.IsPrimary, ts.IsActive, ts.CreatedOn
  FROM TeacherSubjects ts
  JOIN Subjects sub ON ts.SubjectId = sub.SubjectId
  JOIN Classes c ON ts.ClassId = c.ClassId
  LEFT JOIN Sections s ON ts.SectionId = s.SectionId
  WHERE ts.OrganizationId = p_OrganizationId AND ts.TeacherId = p_TeacherId And ts.IsActive = 1;
END$$

DELIMITER ;