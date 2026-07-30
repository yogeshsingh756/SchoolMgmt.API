-- Procedure: sp_RolePermissions_GetByRoleId
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_RolePermissions_GetByRoleId`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_RolePermissions_GetByRoleId` (IN `p_RoleId` INT)   BEGIN
    SELECT 
        rp.RolePermissionId,
        p.PermissionId,
        p.PermissionKey,
        p.PermissionName,
        p.ModuleName,
        rp.CanView,
        rp.CanCreate,
        rp.CanEdit,
        rp.CanDelete
    FROM RolePermissions rp
    INNER JOIN Permissions p ON rp.PermissionId = p.PermissionId
    WHERE rp.RoleId = p_RoleId;
END$$

DELIMITER ;