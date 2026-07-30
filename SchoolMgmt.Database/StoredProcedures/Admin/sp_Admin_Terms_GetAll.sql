-- Procedure: sp_Admin_Terms_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Terms_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Terms_GetAll` (IN `p_OrganizationId` INT)   BEGIN
    SELECT TermId, OrganizationId, TermName, StartMonth, EndMonth, IsActive, IsDeleted, CreatedOn, ModifiedOn
    FROM AcademicTerms
    WHERE OrganizationId = p_OrganizationId AND (IsDeleted = 0 OR IsDeleted IS NULL)
    ORDER BY TermName;
END$$

DELIMITER ;