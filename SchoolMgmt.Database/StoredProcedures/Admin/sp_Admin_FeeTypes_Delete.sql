-- Procedure: sp_Admin_FeeTypes_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_FeeTypes_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_FeeTypes_Delete` (IN `p_FeeTypeId` INT, IN `p_OrganizationId` INT, IN `p_ModifiedBy` INT)   BEGIN
    UPDATE FeeTypes
    SET IsDeleted = 1,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE FeeTypeId = p_FeeTypeId AND OrganizationId = p_OrganizationId;
    SELECT 1 AS SuccessFlag, 'Fee type deleted (soft delete).' AS Message;
END$$

DELIMITER ;