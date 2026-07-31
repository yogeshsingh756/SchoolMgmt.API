-- Procedure: sp_Admin_Sections_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sections_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Sections_GetAll` (IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_IncludeInactive` TINYINT(1))   BEGIN
    SELECT 
        s.SectionId,
        s.SectionName,
        s.Description,
        s.Capacity,
        s.ClassId,
        c.ClassName,
        c.AcademicYear,
        s.ClassTeacherId,
        CONCAT(t.FirstName, ' ', t.LastName) AS ClassTeacherName,
        s.IsActive,
        s.CreatedOn
    FROM Sections s
    INNER JOIN Classes c ON s.ClassId = c.ClassId
    LEFT JOIN Teachers tt ON s.ClassTeacherId = tt.TeacherId
    LEFT JOIN Users t ON tt.UserId = t.UserId
    WHERE 
        s.OrganizationId = p_OrganizationId
        AND (p_ClassId IS NULL OR p_ClassId = 0 OR s.ClassId = p_ClassId) 
        AND (p_IncludeInactive = 1 OR s.IsActive = 1) 
    ORDER BY c.ClassName, s.SectionName;
END$$

DELIMITER ;