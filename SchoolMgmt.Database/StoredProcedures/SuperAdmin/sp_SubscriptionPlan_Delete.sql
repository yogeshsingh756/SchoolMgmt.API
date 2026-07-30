-- Procedure: sp_SubscriptionPlan_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubscriptionPlan_Delete`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SubscriptionPlan_Delete` (IN `p_PlanId` INT, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE SubscriptionPlans
  SET IsDeleted = 1, IsActive = 0, ModifiedBy = p_ModifiedBy
  WHERE PlanId = p_PlanId;
END$$

DELIMITER ;