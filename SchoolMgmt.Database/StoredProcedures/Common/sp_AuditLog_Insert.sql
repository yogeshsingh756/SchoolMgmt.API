-- Procedure: sp_AuditLog_Insert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_AuditLog_Insert`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_AuditLog_Insert` (IN `p_OrganizationId` INT, IN `p_UserId` INT, IN `p_EntityName` VARCHAR(100), IN `p_ActionType` VARCHAR(50), IN `p_EntityKey` VARCHAR(100), IN `p_Description` TEXT, IN `p_OldValue` JSON, IN `p_NewValue` JSON, IN `p_IpAddress` VARCHAR(45), IN `p_UserAgent` VARCHAR(255))   BEGIN
    INSERT INTO AuditLogs (
        OrganizationId, UserId, EntityName, ActionType, EntityKey,
        Description, OldValue, NewValue, IpAddress, UserAgent, CreatedOn
    )
    VALUES (
        p_OrganizationId, p_UserId, p_EntityName, p_ActionType, p_EntityKey,
        p_Description, p_OldValue, p_NewValue, p_IpAddress, p_UserAgent, NOW()
    );
END$$

DELIMITER ;