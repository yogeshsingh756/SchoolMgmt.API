-- Procedure: sp_SubModule_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubModule_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_SubModule_Delete` (IN `p_SubModuleId` INT, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE SubModules
  SET IsActive = 0, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
  WHERE SubModuleId = p_SubModuleId;

  SELECT 1 AS SuccessFlag, 'SubModule deleted' AS Message;
END$$

DELIMITER ;