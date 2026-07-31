-- Procedure: sp_Role_SoftDelete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Role_SoftDelete`;

DELIMITER $$

CREATE PROCEDURE `sp_Role_SoftDelete` (IN `p_RoleId` INT, IN `p_ModifiedBy` INT)   BEGIN
    UPDATE Roles
    SET IsDeleted = 1, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
    WHERE RoleId = p_RoleId;

    SELECT 1 AS SuccessFlag, 'Role deleted successfully' AS Message;
END$$

DELIMITER ;