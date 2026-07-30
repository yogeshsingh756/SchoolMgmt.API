-- Procedure: sp_Fees_GetAllByOrganization
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Fees_GetAllByOrganization`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Fees_GetAllByOrganization` (IN `p_OrganizationId` INT)   BEGIN
    SELECT 
        f.FeeId,
        f.OrganizationId,
        f.ClassId,
        c.ClassName,
        f.FeeType,
        f.Amount,
        f.Term,
        f.Session,
        f.DueDate,
        f.Status,
        f.CreatedOn,
        f.ModifiedOn
    FROM Fees f
    INNER JOIN Classes c ON f.ClassId = c.ClassId
    WHERE f.OrganizationId = p_OrganizationId
      AND f.IsDeleted = 0
    ORDER BY c.ClassName, f.FeeType;
END$$

DELIMITER ;