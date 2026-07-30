-- Procedure: sp_Admin_Classes_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Classes_Delete`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Classes_Delete` (IN `p_ClassId` INT, IN `p_OrganizationId` INT, IN `p_ModifiedBy` INT)   BEGIN
    UPDATE Classes
    SET 
        IsDeleted = 1,
        IsActive = 0,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE ClassId = p_ClassId
      AND OrganizationId = p_OrganizationId;

    SELECT 1 AS SuccessFlag, 'Class deleted successfully.' AS Message;
END$$

DELIMITER ;