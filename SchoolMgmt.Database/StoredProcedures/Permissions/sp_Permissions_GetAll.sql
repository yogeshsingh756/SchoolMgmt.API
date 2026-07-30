-- Procedure: sp_Permissions_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Permissions_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Permissions_GetAll` ()   BEGIN
    SELECT 
        p.PermissionId,
        p.PermissionKey,
        p.PermissionName,
        p.ModuleId,
        p.SubModuleId,

        -- ???? Added Join for SubModuleName
        m.ModuleName,
        sm.SubModuleName,  -- ???? NEW COLUMN
        p.DESCRIPTION AS DESCRIPTION,
        p.IsActive,
        p.CreatedOn
    FROM Permissions p
    LEFT JOIN Modules m 
        ON p.ModuleId = m.ModuleId
    LEFT JOIN SubModules sm 
        ON p.SubModuleId = sm.SubModuleId  -- ???? NEW JOIN
    WHERE p.IsActive = 1
      AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
    ORDER BY m.ModuleName, sm.SubModuleName, p.PermissionName; -- ???? Sorted cleanly
END$$

DELIMITER ;