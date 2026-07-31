-- Procedure: sp_Admin_FeeTypes_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_FeeTypes_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_FeeTypes_Upsert` (IN `p_FeeTypeId` INT, IN `p_OrganizationId` INT, IN `p_FeeTypeName` VARCHAR(100), IN `p_Description` VARCHAR(255), IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    IF IFNULL(p_FeeTypeId,0) = 0 THEN
        INSERT INTO FeeTypes (OrganizationId, FeeTypeName, DESCRIPTION, IsActive, IsDeleted, CreatedBy, CreatedOn)
        VALUES (p_OrganizationId, p_FeeTypeName, p_Description, IFNULL(p_IsActive,1), 0, p_ModifiedBy, NOW());
        SELECT LAST_INSERT_ID() AS NewId, 'Created' AS ActionTaken;
    ELSE
        UPDATE FeeTypes
        SET FeeTypeName = p_FeeTypeName,
            DESCRIPTION = p_Description,
            IsActive = IFNULL(p_IsActive,1),
            ModifiedBy = p_ModifiedBy,
            ModifiedOn = NOW()
        WHERE FeeTypeId = p_FeeTypeId AND OrganizationId = p_OrganizationId;
        SELECT p_FeeTypeId AS NewId, 'Updated' AS ActionTaken;
    END IF;
END$$

DELIMITER ;