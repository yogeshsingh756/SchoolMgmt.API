-- Procedure: sp_TenantSubscription_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_TenantSubscription_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_TenantSubscription_Create` (IN `p_OrganizationId` INT, IN `p_PlanId` INT, IN `p_IsTrial` TINYINT(1), IN `p_StartAt` DATETIME, IN `p_CustomMonths` INT, IN `p_CreatedBy` INT, OUT `o_TenantSubscriptionId` INT)   BEGIN
  DECLARE v_BillingCycle VARCHAR(20);
  DECLARE v_CustomMonthsPlan INT DEFAULT NULL;
  DECLARE v_ExpiresAt DATETIME;

  -- Fetch plan info
  SELECT BillingCycle, CustomMonths INTO v_BillingCycle, v_CustomMonthsPlan
  FROM SubscriptionPlans WHERE PlanId = p_PlanId AND IsDeleted = 0 LIMIT 1;

  IF v_BillingCycle = 'OneTime' THEN
    SET v_ExpiresAt = DATE_ADD(p_StartAt, INTERVAL 100 YEAR);
  ELSEIF v_BillingCycle = 'Monthly' THEN
    SET v_ExpiresAt = DATE_ADD(p_StartAt, INTERVAL 1 MONTH);
  ELSEIF v_BillingCycle = 'Quarterly' THEN
    SET v_ExpiresAt = DATE_ADD(p_StartAt, INTERVAL 3 MONTH);
  ELSEIF v_BillingCycle = 'SemiAnnual' THEN
    SET v_ExpiresAt = DATE_ADD(p_StartAt, INTERVAL 6 MONTH);
  ELSEIF v_BillingCycle = 'Yearly' THEN
    SET v_ExpiresAt = DATE_ADD(p_StartAt, INTERVAL 12 MONTH);
  ELSEIF v_BillingCycle = 'Custom' THEN
    SET v_ExpiresAt = DATE_ADD(p_StartAt, INTERVAL IFNULL(p_CustomMonths, v_CustomMonthsPlan) MONTH);
  ELSE
    SET v_ExpiresAt = NULL;
  END IF;

  INSERT INTO TenantSubscriptions (
      OrganizationId, PlanId, StartedAt, ExpiresAt,
      IsTrial, STATUS, CreatedOn, ModifiedBy
  )
  VALUES (
      p_OrganizationId, p_PlanId, p_StartAt, v_ExpiresAt,
      p_IsTrial, 'Active', NOW(), p_CreatedBy
  );

  SET o_TenantSubscriptionId = LAST_INSERT_ID();

  -- Activate org if needed
  UPDATE Organizations
     SET IsActive = 1, ModifiedOn = NOW(), ModifiedBy = p_CreatedBy
   WHERE OrganizationId = p_OrganizationId;
END$$

DELIMITER ;