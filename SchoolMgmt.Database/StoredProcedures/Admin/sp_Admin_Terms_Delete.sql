-- Procedure: sp_Admin_Terms_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Terms_Delete`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Terms_Delete` (IN `p_TermId` INT, IN `p_OrganizationId` INT, IN `p_ModifiedBy` INT)   BEGIN
    UPDATE AcademicTerms
    SET IsDeleted = 1,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE TermId = p_TermId AND OrganizationId = p_OrganizationId;
    SELECT 1 AS SuccessFlag, 'Term deleted (soft delete).' AS Message;
END$$

DELIMITER ;