-- Procedure: sp_Admin_Classes_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Classes_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Classes_GetAll` (IN `p_OrganizationId` INT)   BEGIN
    SELECT 
        c.ClassId,
        c.ClassName,
        c.Description,
        c.AcademicYear,
        c.ClassTeacherId,
        CONCAT(u.FirstName, ' ', u.LastName) AS ClassTeacherName,
        c.OrderNo,
        c.IsActive,
        c.CreatedOn
    FROM Classes c
LEFT JOIN Teachers t ON c.ClassTeacherId = t.TeacherId
LEFT JOIN Users u ON t.UserId = u.UserId
    WHERE c.OrganizationId = p_OrganizationId
      AND c.IsDeleted = 0
    ORDER BY c.OrderNo, c.ClassName;
END$$

DELIMITER ;