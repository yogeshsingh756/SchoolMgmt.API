-- Procedure: sp_Admin_Sessions_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sessions_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Sessions_GetAll` (IN `p_OrganizationId` INT)   BEGIN
    SELECT SessionId, OrganizationId, SessionName, StartDate, EndDate, IsActive, IsDeleted, CreatedOn, ModifiedOn
    FROM AcademicSessions
    WHERE OrganizationId = p_OrganizationId AND (IsDeleted = 0 OR IsDeleted IS NULL)
    ORDER BY SessionName;
END$$

DELIMITER ;