-- Procedure: sp_SubscriptionPlan_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubscriptionPlan_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_SubscriptionPlan_GetById` (IN `p_PlanId` INT)   BEGIN
  SELECT * FROM SubscriptionPlans WHERE PlanId = p_PlanId AND IsDeleted = 0;
END$$

DELIMITER ;