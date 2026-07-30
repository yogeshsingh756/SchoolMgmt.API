-- Procedure: sp_Admin_Dashboard_GetOverview
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Dashboard_GetOverview`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Dashboard_GetOverview` (IN `p_OrganizationId` INT)   BEGIN
  SELECT 
    -- ???? Students
    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Student' 
        AND u.IsDeleted = 0) AS TotalStudents,
    
    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Student' 
        AND u.IsActive = 1 
        AND u.IsDeleted = 0) AS ActiveStudents,

    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Student' 
        AND u.IsActive = 0 
        AND u.IsDeleted = 0) AS InactiveStudents,

    -- ????‍???? Teachers
    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Teacher' 
        AND u.IsDeleted = 0) AS TotalTeachers,

    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Teacher' 
        AND u.IsActive = 1 
        AND u.IsDeleted = 0) AS ActiveTeachers,

    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Teacher' 
        AND u.IsActive = 0 
        AND u.IsDeleted = 0) AS InactiveTeachers,

    -- ????‍????‍???? Parents
    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Parent' 
        AND u.IsDeleted = 0) AS TotalParents,

    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Parent' 
        AND u.IsActive = 1 
        AND u.IsDeleted = 0) AS ActiveParents,

    (SELECT COUNT(*) 
       FROM Users u 
       JOIN Roles r ON u.RoleId = r.RoleId 
      WHERE u.OrganizationId = p_OrganizationId 
        AND r.RoleName = 'Parent' 
        AND u.IsActive = 0 
        AND u.IsDeleted = 0) AS InactiveParents,

    -- ???? Courses
    (SELECT COUNT(*) 
       FROM Courses 
      WHERE OrganizationId = p_OrganizationId 
        AND IsDeleted = 0) AS TotalCourses,

    -- ???? Classes
    (SELECT COUNT(*) 
       FROM Classes 
      WHERE OrganizationId = p_OrganizationId 
        AND IsDeleted = 0) AS TotalClasses;
END$$

DELIMITER ;