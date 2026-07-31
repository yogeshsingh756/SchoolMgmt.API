-- Procedure: sp_Admin_FeeTypes_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_FeeTypes_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_FeeTypes_GetAll` (IN `p_OrganizationId` INT)   BEGIN
    SELECT FeeTypeId, OrganizationId, FeeTypeName, DESCRIPTION, IsActive, IsDeleted, CreatedOn, ModifiedOn
    FROM FeeTypes
    WHERE OrganizationId = p_OrganizationId AND (IsDeleted = 0 OR IsDeleted IS NULL)
    ORDER BY FeeTypeName;
END$$

DELIMITER ;