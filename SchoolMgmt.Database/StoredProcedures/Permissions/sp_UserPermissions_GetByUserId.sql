-- Procedure: sp_UserPermissions_GetByUserId
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_UserPermissions_GetByUserId`;

DELIMITER $$

CREATE PROCEDURE `sp_UserPermissions_GetByUserId` (IN `p_UserId` INT, IN `p_AdminId` INT)   BEGIN
    /*
        ✅ PURPOSE:
        - If Admin is checking own permissions → return RolePermissions directly.
        - If Admin assigning permissions to a user → show only what Admin can assign.
        - Includes SubModuleName + IsAssigned for front-end grouping.
    */

    IF p_UserId = p_AdminId THEN
        -- ✅ CASE 1: Admin viewing own permissions
        SELECT 
            p.PermissionId,
            p.PermissionKey,
            p.PermissionName,
            p.ModuleName,
            sm.SubModuleName,                                     -- ✅ Added for grouping
            1 AS IsAssigned,                                      -- ✅ Admin always owns their role permissions
            rp.CanView,
            rp.CanCreate,
            rp.CanEdit,
            rp.CanDelete
        FROM RolePermissions rp
        INNER JOIN Permissions p ON p.PermissionId = rp.PermissionId
        LEFT JOIN SubModules sm ON p.SubModuleId = sm.SubModuleId  -- ✅ Added join
        INNER JOIN UserRoles ur ON rp.RoleId = ur.RoleId
        WHERE ur.UserId = p_AdminId
          AND rp.IsDeleted = 0
          AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
          AND (p.IsActive = 1 OR p.IsActive IS NULL)
        ORDER BY p.ModuleName, sm.SubModuleName, p.PermissionName; -- ✅ Sorted for UI
    ELSE
        -- ✅ CASE 2: Admin assigning permissions to a user
        SELECT 
            p.PermissionId,
            p.PermissionKey,
            p.PermissionName,
            p.ModuleName,
            sm.SubModuleName,                                     -- ✅ Added for UI grouping
            CASE WHEN up.UserPermissionId IS NOT NULL THEN 1 ELSE 0 END AS IsAssigned, -- ✅ Added
            COALESCE(up.CanView, 0) AS CanView,
            COALESCE(up.CanCreate, 0) AS CanCreate,
            COALESCE(up.CanEdit, 0) AS CanEdit,
            COALESCE(up.CanDelete, 0) AS CanDelete
        FROM Permissions p
        LEFT JOIN UserPermissions up 
            ON p.PermissionId = up.PermissionId 
           AND up.UserId = p_UserId 
           AND (up.IsDeleted = 0 OR up.IsDeleted IS NULL)
        LEFT JOIN SubModules sm ON p.SubModuleId = sm.SubModuleId  -- ✅ Added join
        WHERE p.PermissionId IN (
            SELECT DISTINCT rp.PermissionId
            FROM Users a
            INNER JOIN UserRoles ur ON a.UserId = ur.UserId
            INNER JOIN RolePermissions rp ON ur.RoleId = rp.RoleId
            WHERE a.UserId = p_AdminId
              AND (rp.IsDeleted = 0 OR rp.IsDeleted IS NULL)
              AND (ur.IsDeleted = 0 OR ur.IsDeleted IS NULL)
        )
        AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
        AND (p.IsActive = 1 OR p.IsActive IS NULL)
        ORDER BY p.ModuleName, sm.SubModuleName, p.PermissionName; -- ✅ Sorted for UI
    END IF;
END$$

DELIMITER ;