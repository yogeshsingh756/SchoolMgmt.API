-- Procedure: sp_RolePermissions_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_RolePermissions_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_RolePermissions_Upsert` (IN `p_RoleId` INT, IN `p_PermissionId` INT, IN `p_CanView` TINYINT(1), IN `p_CanCreate` TINYINT(1), IN `p_CanEdit` TINYINT(1), IN `p_CanDelete` TINYINT(1))   BEGIN
    INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete)
    VALUES (p_RoleId, p_PermissionId, p_CanView, p_CanCreate, p_CanEdit, p_CanDelete)
    ON DUPLICATE KEY UPDATE
        CanView = VALUES(CanView),
        CanCreate = VALUES(CanCreate),
        CanEdit = VALUES(CanEdit),
        CanDelete = VALUES(CanDelete);
END$$

DELIMITER ;