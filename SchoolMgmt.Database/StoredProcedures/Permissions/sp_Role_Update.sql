-- Procedure: sp_Role_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Role_Update`;

DELIMITER $$

CREATE PROCEDURE `sp_Role_Update` (IN `p_RoleId` INT, IN `p_RoleName` VARCHAR(100), IN `p_ModifiedBy` INT)   BEGIN
    UPDATE Roles
    SET RoleName = p_RoleName,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE RoleId = p_RoleId AND IsDeleted = 0;

    SELECT 1 AS SuccessFlag, 'Role updated successfully' AS Message;
END$$

DELIMITER ;