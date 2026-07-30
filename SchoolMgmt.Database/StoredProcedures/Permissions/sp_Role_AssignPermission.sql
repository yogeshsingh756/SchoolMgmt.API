-- Procedure: sp_Role_AssignPermission
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Role_AssignPermission`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Role_AssignPermission` (IN `p_RoleId` INT, IN `p_PermissionId` INT, IN `p_CanView` TINYINT(1), IN `p_CanCreate` TINYINT(1), IN `p_CanEdit` TINYINT(1), IN `p_CanDelete` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedBy, CreatedOn)
    VALUES (p_RoleId, p_PermissionId, p_CanView, p_CanCreate, p_CanEdit, p_CanDelete, p_ModifiedBy, NOW())
    ON DUPLICATE KEY UPDATE 
        CanView = VALUES(CanView),
        CanCreate = VALUES(CanCreate),
        CanEdit = VALUES(CanEdit),
        CanDelete = VALUES(CanDelete),
        ModifiedBy = VALUES(CreatedBy),
        ModifiedOn = NOW();

    SELECT 1 AS SuccessFlag, 'Permission assigned successfully.' AS Message;
END$$

DELIMITER ;