-- Procedure: sp_Admin_FeeTypes_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_FeeTypes_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_FeeTypes_GetById` (IN `p_FeeTypeId` INT, IN `p_OrganizationId` INT)   BEGIN
    SELECT FeeTypeId, OrganizationId, FeeTypeName, DESCRIPTION, IsActive, IsDeleted, CreatedOn, ModifiedOn
    FROM FeeTypes
    WHERE FeeTypeId = p_FeeTypeId AND OrganizationId = p_OrganizationId AND (IsDeleted = 0 OR IsDeleted IS NULL)
    LIMIT 1;
END$$

DELIMITER ;