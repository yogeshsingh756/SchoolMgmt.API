-- Procedure: sp_UserPermissions_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_UserPermissions_Upsert`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_UserPermissions_Upsert` (IN `p_UserId` INT, IN `p_PermissionId` INT, IN `p_CanView` TINYINT(1), IN `p_CanCreate` TINYINT(1), IN `p_CanEdit` TINYINT(1), IN `p_CanDelete` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    INSERT INTO UserPermissions (UserId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, ModifiedBy)
    VALUES (p_UserId, p_PermissionId, p_CanView, p_CanCreate, p_CanEdit, p_CanDelete, p_ModifiedBy)
    ON DUPLICATE KEY UPDATE 
        CanView = VALUES(CanView),
        CanCreate = VALUES(CanCreate),
        CanEdit = VALUES(CanEdit),
        CanDelete = VALUES(CanDelete),
        ModifiedBy = VALUES(ModifiedBy),
        ModifiedOn = NOW();
END$$

DELIMITER ;