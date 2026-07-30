-- Procedure: sp_SubModule_GetByModule
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubModule_GetByModule`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SubModule_GetByModule` (IN `p_ModuleId` INT)   BEGIN
  SELECT 
      s.SubModuleId,
      s.ModuleId,
      s.SubModuleName,
      s.DESCRIPTION,
      s.RoutePath,
      s.OrderNo,
      s.IsActive,
      s.CreatedOn,

      -- ✅ Comma-separated RoleIds assigned via RolePermissions → Permissions
      (
          SELECT GROUP_CONCAT(DISTINCT rp.RoleId ORDER BY rp.RoleId)
          FROM RolePermissions rp
          INNER JOIN Permissions p ON rp.PermissionId = p.PermissionId
          WHERE p.SubModuleId = s.SubModuleId
      ) AS AssignedRoleIds

  FROM SubModules s
  WHERE s.ModuleId = p_ModuleId 
    AND s.IsActive = 1
  ORDER BY s.OrderNo, s.SubModuleName;
END$$

DELIMITER ;