-- Procedure: sp_Role_GetPermissions
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Role_GetPermissions`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Role_GetPermissions` (IN `p_RoleId` INT)   BEGIN
    SELECT 
        p.PermissionId,
        p.PermissionKey,
        p.PermissionName,
        COALESCE(rp.CanView, 0) AS CanView,
        COALESCE(rp.CanCreate, 0) AS CanCreate,
        COALESCE(rp.CanEdit, 0) AS CanEdit,
        COALESCE(rp.CanDelete, 0) AS CanDelete
    FROM Permissions p
    LEFT JOIN RolePermissions rp 
        ON rp.PermissionId = p.PermissionId AND rp.RoleId = p_RoleId
    WHERE p.IsActive = 1
    ORDER BY p.PermissionKey;
END$$

DELIMITER ;