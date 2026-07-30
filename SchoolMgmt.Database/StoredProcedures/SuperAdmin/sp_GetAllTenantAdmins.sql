-- Procedure: sp_GetAllTenantAdmins
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_GetAllTenantAdmins`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_GetAllTenantAdmins` ()   BEGIN
    SELECT 
        u.UserId AS AdminUserId,
        CONCAT(u.FirstName, ' ', u.LastName) AS AdminName,
        u.Email,
        u.Username,
        o.OrganizationId,
        o.SchoolName AS OrganizationName,
        r.RoleName
    FROM Users u
    INNER JOIN Organizations o ON u.OrganizationId = o.OrganizationId
    INNER JOIN Roles r ON u.RoleId = r.RoleId
    WHERE 
        r.RoleName = 'Admin'
        AND u.IsDeleted = 0
        AND o.IsDeleted = 0
        -- AND o.TenantStatus = 'Active'
    ORDER BY o.SchoolName ASC, AdminName ASC;
END$$

DELIMITER ;