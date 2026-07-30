-- Procedure: sp_Admin_Sessions_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sessions_Upsert`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Sessions_Upsert` (IN `p_SessionId` INT, IN `p_OrganizationId` INT, IN `p_SessionName` VARCHAR(50), IN `p_StartDate` DATE, IN `p_EndDate` DATE, IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    IF IFNULL(p_SessionId,0) = 0 THEN
        INSERT INTO AcademicSessions (OrganizationId, SessionName, StartDate, EndDate, IsActive, IsDeleted, CreatedBy, CreatedOn)
        VALUES (p_OrganizationId, p_SessionName, p_StartDate, p_EndDate, IFNULL(p_IsActive,1), 0, p_ModifiedBy, NOW());
        SELECT LAST_INSERT_ID() AS NewId, 'Created' AS ActionTaken;
    ELSE
        UPDATE AcademicSessions
        SET SessionName = p_SessionName,
            StartDate = p_StartDate,
            EndDate   = p_EndDate,
            IsActive  = IFNULL(p_IsActive,1),
            ModifiedBy = p_ModifiedBy,
            ModifiedOn = NOW()
        WHERE SessionId = p_SessionId AND OrganizationId = p_OrganizationId;
        SELECT p_SessionId AS NewId, 'Updated' AS ActionTaken;
    END IF;
END$$

DELIMITER ;