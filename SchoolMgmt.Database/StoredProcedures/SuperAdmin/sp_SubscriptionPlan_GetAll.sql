-- Procedure: sp_SubscriptionPlan_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubscriptionPlan_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SubscriptionPlan_GetAll` ()   BEGIN
  SELECT * FROM SubscriptionPlans WHERE IsDeleted = 0;
END$$

DELIMITER ;