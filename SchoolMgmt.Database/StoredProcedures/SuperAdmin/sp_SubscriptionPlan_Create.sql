-- Procedure: sp_SubscriptionPlan_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubscriptionPlan_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SubscriptionPlan_Create` (IN `p_PlanName` VARCHAR(150), IN `p_Description` TEXT, IN `p_Price` DECIMAL(10,2), IN `p_BillingCycle` VARCHAR(20), IN `p_CustomMonths` INT, IN `p_CreatedBy` INT, OUT `o_PlanId` INT)   BEGIN
  INSERT INTO SubscriptionPlans (PlanName, Description, Price, BillingCycle, CustomMonths, CreatedBy)
  VALUES (p_PlanName, p_Description, p_Price, p_BillingCycle, p_CustomMonths, p_CreatedBy);

  SET o_PlanId = LAST_INSERT_ID();
END$$

DELIMITER ;