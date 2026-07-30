-- Procedure: sp_Role_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Role_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Role_Create` (IN `p_RoleName` VARCHAR(100), IN `p_CreatedBy` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM Roles WHERE RoleName = p_RoleName AND IsDeleted = 0) THEN
        SELECT 0 AS SuccessFlag, 'Role already exists' AS Message;
    ELSE
        INSERT INTO Roles (RoleName, CreatedBy, CreatedOn)
        VALUES (p_RoleName, p_CreatedBy, NOW());
        SELECT 1 AS SuccessFlag, 'Role created successfully' AS Message;
    END IF;
END$$

DELIMITER ;