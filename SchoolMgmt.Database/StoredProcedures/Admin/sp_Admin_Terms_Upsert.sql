-- Procedure: sp_Admin_Terms_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Terms_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Terms_Upsert` (IN `p_TermId` INT, IN `p_OrganizationId` INT, IN `p_TermName` VARCHAR(50), IN `p_StartMonth` INT, IN `p_EndMonth` INT, IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    IF IFNULL(p_TermId,0) = 0 THEN
        INSERT INTO AcademicTerms (OrganizationId, TermName, StartMonth, EndMonth, IsActive, IsDeleted, CreatedBy, CreatedOn)
        VALUES (p_OrganizationId, p_TermName, p_StartMonth, p_EndMonth, IFNULL(p_IsActive,1), 0, p_ModifiedBy, NOW());
        SELECT LAST_INSERT_ID() AS NewId, 'Created' AS ActionTaken;
    ELSE
        UPDATE AcademicTerms
        SET TermName = p_TermName,
            StartMonth = p_StartMonth,
            EndMonth = p_EndMonth,
            IsActive = IFNULL(p_IsActive,1),
            ModifiedBy = p_ModifiedBy,
            ModifiedOn = NOW()
        WHERE TermId = p_TermId AND OrganizationId = p_OrganizationId;
        SELECT p_TermId AS NewId, 'Updated' AS ActionTaken;
    END IF;
END$$

DELIMITER ;