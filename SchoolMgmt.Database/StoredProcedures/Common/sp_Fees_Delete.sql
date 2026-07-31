-- Procedure: sp_Fees_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Fees_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Fees_Delete` (IN `p_FeeId` INT, IN `p_OrganizationId` INT, IN `p_ModifiedBy` INT)   BEGIN
    UPDATE Fees
    SET IsDeleted = 1,
        ModifiedOn = NOW(),
        ModifiedBy = p_ModifiedBy
    WHERE FeeId = p_FeeId
      AND OrganizationId = p_OrganizationId;
END$$

DELIMITER ;