-- Procedure: sp_SubModule_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubModule_Update`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SubModule_Update` (IN `p_SubModuleId` INT, IN `p_SubModuleName` VARCHAR(100), IN `p_Description` VARCHAR(255), IN `p_RoutePath` VARCHAR(200), IN `p_OrderNo` INT, IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT, IN `p_AssignedRoleIds` TEXT)   BEGIN
    -- ???? VARIABLES
    DECLARE v_OldSubModuleName VARCHAR(100);
    DECLARE v_ModuleId INT;
    DECLARE v_ModuleName VARCHAR(100);
    DECLARE v_RoleId INT;
    DECLARE done INT DEFAULT 0;

    -- ???? CURSOR (must be declared before handlers)
    DECLARE cur CURSOR FOR 
        SELECT CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_AssignedRoleIds, ',', n.n), ',', -1)) AS UNSIGNED)
        FROM (
            SELECT a.N + b.N * 10 + 1 n
            FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
                 (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
        ) n
        WHERE n.n <= 1 + (LENGTH(p_AssignedRoleIds) - LENGTH(REPLACE(p_AssignedRoleIds, ',', '')));

    -- ???? HANDLERS (must come after cursor)
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- ⚠️ NEW: Transaction rollback handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occurred during SubModule update. Transaction rolled back.';
    END;

    -- ⚙️ NEW: Begin transaction
    START TRANSACTION;

    -- Fetch existing names
    SELECT SubModuleName, ModuleId INTO v_OldSubModuleName, v_ModuleId
    FROM SubModules
    WHERE SubModuleId = p_SubModuleId;

    SELECT ModuleName INTO v_ModuleName
    FROM Modules WHERE ModuleId = v_ModuleId;

    -- Update submodule record
    UPDATE SubModules
    SET 
        SubModuleName = p_SubModuleName,
        DESCRIPTION = p_Description,
        RoutePath = p_RoutePath,
        OrderNo = IFNULL(p_OrderNo, 0),
        IsActive = IFNULL(p_IsActive, 1),
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE SubModuleId = p_SubModuleId;

    -- If submodule name changed, update permissions
    IF v_OldSubModuleName <> p_SubModuleName THEN
        UPDATE Permissions
        SET PermissionKey = REPLACE(PermissionKey, v_OldSubModuleName, p_SubModuleName),
            PermissionName = REPLACE(PermissionName, v_OldSubModuleName, p_SubModuleName),
            DESCRIPTION = REPLACE(DESCRIPTION, v_OldSubModuleName, p_SubModuleName)
        WHERE SubModuleId = p_SubModuleId;

        UPDATE Permissions
        SET ModuleName = v_ModuleName
        WHERE SubModuleId = p_SubModuleId;
    END IF;

    -- ???? NEW: Remove old role mappings not in updated list
    IF p_AssignedRoleIds IS NOT NULL AND p_AssignedRoleIds <> '' THEN
        DELETE rp FROM RolePermissions rp
        INNER JOIN Permissions p ON rp.PermissionId = p.PermissionId
        WHERE p.SubModuleId = p_SubModuleId
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

    -- ✅ Assign new permissions to roles
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
            WHERE SubModuleId = p_SubModuleId
              AND NOT EXISTS (
                  SELECT 1 FROM RolePermissions 
                  WHERE RoleId = v_RoleId AND PermissionId = Permissions.PermissionId
              );
        END LOOP;
        CLOSE cur;
    END IF;

    -- ✅ NEW: Commit transaction
    COMMIT;

    SELECT 1 AS SuccessFlag, 'SubModule updated successfully.' AS Message;
END$$

DELIMITER ;