-- Procedure: sp_Admin_ClassFeeMaster_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_ClassFeeMaster_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_ClassFeeMaster_Delete` (IN `p_OrganizationId` INT, IN `p_ClassFeeId` INT, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE ClassFeeMaster
     SET IsDeleted = 1,
         IsActive = 0,
         ModifiedBy = p_ModifiedBy,
         ModifiedOn = NOW()
   WHERE OrganizationId = p_OrganizationId
     AND ClassFeeId = p_ClassFeeId
     AND IsDeleted = 0;

  SELECT 1 AS SuccessFlag, 'Deleted' AS Message;
END$$

DELIMITER ;