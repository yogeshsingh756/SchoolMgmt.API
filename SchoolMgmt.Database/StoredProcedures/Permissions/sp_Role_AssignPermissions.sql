-- Procedure: sp_Role_AssignPermissions
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Role_AssignPermissions`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Role_AssignPermissions` (IN `p_RoleId` INT, IN `p_PermissionId` INT, IN `p_CanView` TINYINT(1), IN `p_CanCreate` TINYINT(1), IN `p_CanEdit` TINYINT(1), IN `p_CanDelete` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM RolePermissions WHERE RoleId = p_RoleId AND PermissionId = p_PermissionId) THEN
        UPDATE RolePermissions
        SET CanView = p_CanView,
            CanCreate = p_CanCreate,
            CanEdit = p_CanEdit,
            CanDelete = p_CanDelete,
            ModifiedBy = p_ModifiedBy,
            ModifiedOn = NOW()
        WHERE RoleId = p_RoleId AND PermissionId = p_PermissionId;
    ELSE
        INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn, CreatedBy)
        VALUES (p_RoleId, p_PermissionId, p_CanView, p_CanCreate, p_CanEdit, p_CanDelete, NOW(), p_ModifiedBy);
    END IF;
    SELECT 1 AS SuccessFlag, 'Permissions updated successfully' AS Message;
END$$

DELIMITER ;