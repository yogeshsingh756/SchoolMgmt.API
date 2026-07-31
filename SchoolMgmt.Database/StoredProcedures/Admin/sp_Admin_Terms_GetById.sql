-- Procedure: sp_Admin_Terms_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Terms_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Terms_GetById` (IN `p_TermId` INT, IN `p_OrganizationId` INT)   BEGIN
    SELECT TermId, OrganizationId, TermName, StartMonth, EndMonth, IsActive, IsDeleted, CreatedOn, ModifiedOn
    FROM AcademicTerms
    WHERE TermId = p_TermId AND OrganizationId = p_OrganizationId AND (IsDeleted = 0 OR IsDeleted IS NULL)
    LIMIT 1;
END$$

DELIMITER ;