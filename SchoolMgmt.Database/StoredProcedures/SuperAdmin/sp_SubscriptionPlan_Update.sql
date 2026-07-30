-- Procedure: sp_SubscriptionPlan_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SubscriptionPlan_Update`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SubscriptionPlan_Update` (IN `p_PlanId` INT, IN `p_PlanName` VARCHAR(150), IN `p_Description` TEXT, IN `p_Price` DECIMAL(10,2), IN `p_BillingCycle` VARCHAR(20), IN `p_CustomMonths` INT, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE SubscriptionPlans
    SET PlanName = p_PlanName,
        Description = p_Description,
        Price = p_Price,
        BillingCycle = p_BillingCycle,
        CustomMonths = p_CustomMonths,
        ModifiedBy = p_ModifiedBy
  WHERE PlanId = p_PlanId;
END$$

DELIMITER ;