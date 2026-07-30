-- Procedure: sp_Admin_Sessions_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sessions_GetById`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Sessions_GetById` (IN `p_SessionId` INT, IN `p_OrganizationId` INT)   BEGIN
    SELECT SessionId, OrganizationId, SessionName, StartDate, EndDate, IsActive, IsDeleted, CreatedOn, ModifiedOn
    FROM AcademicSessions
    WHERE SessionId = p_SessionId AND OrganizationId = p_OrganizationId AND (IsDeleted = 0 OR IsDeleted IS NULL)
    LIMIT 1;
END$$

DELIMITER ;