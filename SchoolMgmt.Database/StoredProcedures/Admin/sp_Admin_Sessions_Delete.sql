-- Procedure: sp_Admin_Sessions_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sessions_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Sessions_Delete` (IN `p_SessionId` INT, IN `p_OrganizationId` INT, IN `p_ModifiedBy` INT)   BEGIN
    UPDATE AcademicSessions
    SET IsDeleted = 1,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE SessionId = p_SessionId AND OrganizationId = p_OrganizationId;
    SELECT 1 AS SuccessFlag, 'Session deleted (soft delete).' AS Message;
END$$

DELIMITER ;