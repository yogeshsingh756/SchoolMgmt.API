-- Procedure: sp_Module_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Module_Delete`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Module_Delete` (IN `p_ModuleId` INT, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE Modules
  SET IsActive = 0, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
  WHERE ModuleId = p_ModuleId;

  SELECT 1 AS SuccessFlag, 'Module deleted' AS Message;
END$$

DELIMITER ;