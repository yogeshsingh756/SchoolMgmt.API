-- Procedure: sp_Role_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Role_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Role_GetAll` ()   BEGIN
    SELECT RoleId, RoleName, CreatedOn, ModifiedOn, IsDeleted
    FROM Roles
    WHERE IsDeleted = 0
    ORDER BY RoleId ASC;
END$$

DELIMITER ;