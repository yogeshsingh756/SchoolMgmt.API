-- Procedure: sp_User_GetEffectivePermissions
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_GetEffectivePermissions`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_User_GetEffectivePermissions` (IN `p_UserId` INT)   BEGIN
    /*
        ✅ PURPOSE:
        Combine RolePermissions + UserPermissions (user overrides)
        Used for runtime authorization, dashboard filters, and login.
    */

    SELECT 
        p.PermissionId,
        p.PermissionKey,
        p.PermissionName,
        p.ModuleName,
        sm.SubModuleName,  -- ✅ Added for grouping
        p.Description,
        p.IsActive,

        -- ✅ Effective permissions = max(role vs user override)
        GREATEST(COALESCE(up.CanView, 0), COALESCE(rp.CanView, 0)) AS CanView,
        GREATEST(COALESCE(up.CanCreate, 0), COALESCE(rp.CanCreate, 0)) AS CanCreate,
        GREATEST(COALESCE(up.CanEdit, 0), COALESCE(rp.CanEdit, 0)) AS CanEdit,
        GREATEST(COALESCE(up.CanDelete, 0), COALESCE(rp.CanDelete, 0)) AS CanDelete,

        CASE WHEN up.UserPermissionId IS NOT NULL THEN 1 ELSE 0 END AS IsAssigned

    FROM Users u
    INNER JOIN UserRoles ur ON u.UserId = ur.UserId
    INNER JOIN RolePermissions rp ON ur.RoleId = rp.RoleId
    INNER JOIN Permissions p ON rp.PermissionId = p.PermissionId
    LEFT JOIN UserPermissions up 
        ON up.UserId = u.UserId 
       AND up.PermissionId = p.PermissionId 
       AND (up.IsDeleted = 0 OR up.IsDeleted IS NULL)
    LEFT JOIN SubModules sm ON p.SubModuleId = sm.SubModuleId

    WHERE u.UserId = p_UserId
      AND (rp.IsDeleted = 0 OR rp.IsDeleted IS NULL)
      AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
      AND (p.IsActive = 1 OR p.IsActive IS NULL)
    ORDER BY p.ModuleName, sm.SubModuleName, p.PermissionName;
END$$

DELIMITER ;