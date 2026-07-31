-- Procedure: sp_User_GetEffectivePermissionsForLogin
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_GetEffectivePermissionsForLogin`;

DELIMITER $$

CREATE PROCEDURE `sp_User_GetEffectivePermissionsForLogin` (IN `p_UserId` INT)   BEGIN
    SELECT 
        m.ModuleId,
        m.ModuleName,
        sm.SubModuleId,
        sm.SubModuleName,
        p.PermissionId,
        p.PermissionKey,
        GREATEST(
            COALESCE(up.CanView, rp.CanView, 0),
            COALESCE(rp.CanView, 0)
        ) AS CanView,
        GREATEST(
            COALESCE(up.CanCreate, rp.CanCreate, 0),
            COALESCE(rp.CanCreate, 0)
        ) AS CanCreate,
        GREATEST(
            COALESCE(up.CanEdit, rp.CanEdit, 0),
            COALESCE(rp.CanEdit, 0)
        ) AS CanEdit,
        GREATEST(
            COALESCE(up.CanDelete, rp.CanDelete, 0),
            COALESCE(rp.CanDelete, 0)
        ) AS CanDelete
    FROM Users u
    INNER JOIN UserRoles ur 
        ON u.UserId = ur.UserId
    INNER JOIN RolePermissions rp 
        ON ur.RoleId = rp.RoleId
    INNER JOIN Permissions p 
        ON rp.PermissionId = p.PermissionId
    LEFT JOIN UserPermissions up 
        ON up.UserId = u.UserId AND up.PermissionId = p.PermissionId
    LEFT JOIN Modules m 
        ON p.ModuleId = m.ModuleId
    LEFT JOIN SubModules sm 
        ON p.SubModuleId = sm.SubModuleId
    WHERE u.UserId = p_UserId
      AND (rp.IsDeleted = 0 OR rp.IsDeleted IS NULL)
      AND (m.IsActive = 1 OR m.IsActive IS NULL)
      AND (sm.IsActive = 1 OR sm.IsActive IS NULL)
    ORDER BY m.OrderNo, sm.OrderNo, p.PermissionKey;
END$$

DELIMITER ;