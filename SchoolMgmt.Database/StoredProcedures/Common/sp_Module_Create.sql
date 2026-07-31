-- Procedure: sp_Module_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Module_Create`;

DELIMITER $$

CREATE PROCEDURE `sp_Module_Create` (IN `p_ModuleName` VARCHAR(100), IN `p_Description` VARCHAR(255), IN `p_Icon` VARCHAR(100), IN `p_RoutePath` VARCHAR(200), IN `p_OrderNo` INT, IN `p_CreatedBy` INT, IN `p_AssignedRoleIds` TEXT)   BEGIN
  DECLARE v_ModuleId INT;
  DECLARE done INT DEFAULT 0;
  DECLARE v_RoleId INT;

  -- Cursor for role IDs
  DECLARE cur CURSOR FOR 
      SELECT CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_AssignedRoleIds, ',', n.n), ',', -1)) AS UNSIGNED)
      FROM (
          SELECT a.N + b.N * 10 + 1 n
          FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
               (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
      ) n
      WHERE n.n <= 1 + (LENGTH(p_AssignedRoleIds) - LENGTH(REPLACE(p_AssignedRoleIds, ',', '')));

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  -- Insert module
  INSERT INTO Modules (ModuleName, DESCRIPTION, Icon, RoutePath, OrderNo, CreatedBy)
  VALUES (p_ModuleName, p_Description, p_Icon, p_RoutePath, IFNULL(p_OrderNo,0), p_CreatedBy);

  SET v_ModuleId = LAST_INSERT_ID();

  -- Create default CRUD permissions
  INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, ModuleName, DESCRIPTION, IsActive, CreatedOn)
  VALUES
    (CONCAT(p_ModuleName, '.View'), CONCAT('View ', p_ModuleName), v_ModuleId, p_ModuleName, CONCAT('View ', p_ModuleName), 1, NOW()),
    (CONCAT(p_ModuleName, '.Create'), CONCAT('Create ', p_ModuleName), v_ModuleId, p_ModuleName, CONCAT('Create ', p_ModuleName), 1, NOW()),
    (CONCAT(p_ModuleName, '.Edit'), CONCAT('Edit ', p_ModuleName), v_ModuleId, p_ModuleName, CONCAT('Edit ', p_ModuleName), 1, NOW()),
    (CONCAT(p_ModuleName, '.Delete'), CONCAT('Delete ', p_ModuleName), v_ModuleId, p_ModuleName, CONCAT('Delete ', p_ModuleName), 1, NOW());

  -- Assign permissions to each role if provided
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
      WHERE ModuleId = v_ModuleId
      AND NOT EXISTS (
        SELECT 1 FROM RolePermissions WHERE RoleId = v_RoleId AND PermissionId = Permissions.PermissionId
      );
    END LOOP;
    CLOSE cur;
  END IF;

  SELECT 1 AS SuccessFlag, 'Module created successfully.' AS Message, v_ModuleId AS ModuleId;
END$$

DELIMITER ;