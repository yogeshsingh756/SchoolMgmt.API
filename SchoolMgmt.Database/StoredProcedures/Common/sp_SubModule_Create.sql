-- Procedure: sp_SubModule_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubModule_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SubModule_Create` (IN `p_ModuleId` INT, IN `p_SubModuleName` VARCHAR(100), IN `p_Description` VARCHAR(255), IN `p_RoutePath` VARCHAR(200), IN `p_OrderNo` INT, IN `p_CreatedBy` INT, IN `p_AssignedRoleIds` TEXT)   BEGIN
  DECLARE v_SubModuleId INT;
  DECLARE v_ModName VARCHAR(100);
  DECLARE done INT DEFAULT 0;
  DECLARE v_RoleId INT;

  DECLARE cur CURSOR FOR 
      SELECT CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_AssignedRoleIds, ',', n.n), ',', -1)) AS UNSIGNED)
      FROM (
          SELECT a.N + b.N * 10 + 1 n
          FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
               (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
      ) n
      WHERE n.n <= 1 + (LENGTH(p_AssignedRoleIds) - LENGTH(REPLACE(p_AssignedRoleIds, ',', '')));

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT ModuleName INTO v_ModName FROM Modules WHERE ModuleId = p_ModuleId LIMIT 1;

  INSERT INTO SubModules (ModuleId, SubModuleName, DESCRIPTION, RoutePath, OrderNo, CreatedBy)
  VALUES (p_ModuleId, p_SubModuleName, p_Description, p_RoutePath, IFNULL(p_OrderNo,0), p_CreatedBy);

  SET v_SubModuleId = LAST_INSERT_ID();

  -- Create default CRUD permissions
  INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, SubModuleId, ModuleName, DESCRIPTION, IsActive, CreatedOn)
  VALUES
    (CONCAT(v_ModName, '.', p_SubModuleName, '.View'), CONCAT('View ', p_SubModuleName), p_ModuleId, v_SubModuleId, v_ModName, CONCAT('View ', p_SubModuleName), 1, NOW()),
    (CONCAT(v_ModName, '.', p_SubModuleName, '.Create'), CONCAT('Create ', p_SubModuleName), p_ModuleId, v_SubModuleId, v_ModName, CONCAT('Create ', p_SubModuleName), 1, NOW()),
    (CONCAT(v_ModName, '.', p_SubModuleName, '.Edit'), CONCAT('Edit ', p_SubModuleName), p_ModuleId, v_SubModuleId, v_ModName, CONCAT('Edit ', p_SubModuleName), 1, NOW()),
    (CONCAT(v_ModName, '.', p_SubModuleName, '.Delete'), CONCAT('Delete ', p_SubModuleName), p_ModuleId, v_SubModuleId, v_ModName, CONCAT('Delete ', p_SubModuleName), 1, NOW());

  -- Assign to roles
  IF p_AssignedRoleIds IS NOT NULL AND p_AssignedRoleIds <> '' THEN
    OPEN cur;
    read_loop: LOOP
      FETCH cur INTO v_RoleId;
      IF done THEN
        LEAVE read_loop;
      END IF;

      INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
      SELECT v_RoleId, PermissionId, 1, 1, 1, 1, NOW()
      FROM Permissions
      WHERE SubModuleId = v_SubModuleId
      AND NOT EXISTS (
        SELECT 1 FROM RolePermissions WHERE RoleId = v_RoleId AND PermissionId = Permissions.PermissionId
      );
    END LOOP;
    CLOSE cur;
  END IF;

  SELECT 1 AS SuccessFlag, 'SubModule created successfully.' AS Message, v_SubModuleId AS SubModuleId;
END$$

DELIMITER ;