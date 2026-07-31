-- Procedure: sp_Fees_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Fees_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Fees_GetById` (IN `p_FeeId` INT, IN `p_OrganizationId` INT)   BEGIN
    SELECT 
        FeeId,
        OrganizationId,
        ClassId,
        FeeType,
        Amount,
        DueDate,
        Term,
        Session,
        Status,
        CreatedOn,
        ModifiedOn
    FROM Fees
    WHERE FeeId = p_FeeId
      AND OrganizationId = p_OrganizationId
      AND IsDeleted = 0;
END$$

DELIMITER ;