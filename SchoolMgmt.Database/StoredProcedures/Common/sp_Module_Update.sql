-- Procedure: sp_Module_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Module_Update`;

DELIMITER $$

CREATE PROCEDURE `sp_Module_Update` (IN `p_ModuleId` INT, IN `p_ModuleName` VARCHAR(100), IN `p_Description` VARCHAR(255), IN `p_Icon` VARCHAR(100), IN `p_RoutePath` VARCHAR(200), IN `p_OrderNo` INT, IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT, IN `p_AssignedRoleIds` TEXT)   BEGIN
    -- ???? Variable Declarations
    DECLARE v_OldModuleName VARCHAR(100);
    DECLARE v_RoleId INT;
    DECLARE done INT DEFAULT 0;

    -- ???? Cursor Declaration (must come BEFORE handlers in MariaDB)
    DECLARE cur CURSOR FOR 
        SELECT CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_AssignedRoleIds, ',', n.n), ',', -1)) AS UNSIGNED)
        FROM (
            SELECT a.N + b.N * 10 + 1 n
            FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
                 (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
        ) n
        WHERE n.n <= 1 + (LENGTH(p_AssignedRoleIds) - LENGTH(REPLACE(p_AssignedRoleIds, ',', '')));

    -- ???? Handler Declarations (must come AFTER cursors)
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occurred during module update. Transaction rolled back.';
    END;

    -- ⚙️ Start transaction
    START TRANSACTION;

    -- Fetch old name
    SELECT ModuleName INTO v_OldModuleName FROM Modules WHERE ModuleId = p_ModuleId;

    -- Update module details
    UPDATE Modules
    SET 
        ModuleName = p_ModuleName,
        DESCRIPTION = p_Description,
        Icon = p_Icon,
        RoutePath = p_RoutePath,
        OrderNo = IFNULL(p_OrderNo, 0),
        IsActive = IFNULL(p_IsActive, 1),
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE ModuleId = p_ModuleId;

    -- If name changed, update related tables
    IF v_OldModuleName <> p_ModuleName THEN
        UPDATE Permissions
        SET PermissionKey = REPLACE(PermissionKey, v_OldModuleName, p_ModuleName),
            ModuleName = p_ModuleName,
            DESCRIPTION = REPLACE(DESCRIPTION, v_OldModuleName, p_ModuleName)
        WHERE ModuleId = p_ModuleId;

        UPDATE SubModules
        SET DESCRIPTION = REPLACE(IFNULL(DESCRIPTION, ''), v_OldModuleName, p_ModuleName)
        WHERE ModuleId = p_ModuleId;
    END IF;

    -- ???? Remove old role mappings not in updated list
    IF p_AssignedRoleIds IS NOT NULL AND p_AssignedRoleIds <> '' THEN
        DELETE rp FROM RolePermissions rp
        INNER JOIN Permissions p ON rp.PermissionId = p.PermissionId
        WHERE p.ModuleId = p_ModuleId
          AND rp.RoleId NOT IN (
              SELECT CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_AssignedRoleIds, ',', n.n), ',', -1)) AS UNSIGNED)
              FROM (
                  SELECT a.N + b.N * 10 + 1 n
                  FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
                       (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
              ) n
              WHERE n.n <= 1 + (LENGTH(p_AssignedRoleIds) - LENGTH(REPLACE(p_AssignedRoleIds, ',', '')))
          );
    END IF;

    -- ✅ Add new role permissions
    IF p_AssignedRoleIds IS NOT NULL AND p_AssignedRoleIds <> '' THEN
        OPEN cur;
        read_loop: LOOP
            FETCH cur INTO v_RoleId;
            IF done THEN
                LEAVE read_loop;
            END IF;

            INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
            SELECT v_RoleId, PermissionId, 1,1,1,1, NOW()
            FROM Permissions
            WHERE ModuleId = p_ModuleId
              AND NOT EXISTS (
                  SELECT 1 FROM RolePermissions 
                  WHERE RoleId = v_RoleId AND PermissionId = Permissions.PermissionId
              );
        END LOOP;
        CLOSE cur;
    END IF;

    -- ✅ Commit transaction
    COMMIT;

    SELECT 1 AS SuccessFlag, 'Module updated successfully.' AS Message;
END$$

DELIMITER ;