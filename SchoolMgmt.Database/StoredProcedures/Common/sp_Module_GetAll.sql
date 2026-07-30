-- Procedure: sp_Module_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Module_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Module_GetAll` ()   BEGIN
  SELECT 
      m.ModuleId,
      m.ModuleName,
      m.DESCRIPTION,
      m.Icon,
      m.RoutePath,
      m.OrderNo,
      m.IsActive,
      m.CreatedOn,
      
      -- ✅ Comma-separated RoleIds that have any permission in this module
      (
          SELECT GROUP_CONCAT(DISTINCT rp.RoleId ORDER BY rp.RoleId)
          FROM RolePermissions rp
          INNER JOIN Permissions p ON rp.PermissionId = p.PermissionId
          WHERE p.ModuleId = m.ModuleId
      ) AS AssignedRoleIds

  FROM Modules m
  WHERE m.IsActive = 1
  ORDER BY m.OrderNo, m.ModuleName;
END$$

DELIMITER ;