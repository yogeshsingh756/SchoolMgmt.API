-- Procedure: sp_Admin_Sections_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sections_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Sections_Delete` (IN `p_SectionId` INT, IN `p_OrganizationId` INT, IN `p_ModifiedBy` INT)   BEGIN
    UPDATE Sections
    SET 
        IsActive = 0,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE SectionId = p_SectionId AND OrganizationId = p_OrganizationId;

    SELECT 1 AS SuccessFlag, 'Section deleted successfully.' AS Message;
END$$

DELIMITER ;