-- Procedure: sp_Tenant_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Tenant_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Tenant_GetById` (IN `p_OrganizationId` INT)   BEGIN
    SELECT 
        o.OrganizationId,
        o.SchoolName,
        o.Email,
        o.Phone,
        o.IsActive,
        o.LogoUrl,
        ts.PlanId,
        sp.PlanName,
        sp.BillingCycle,
        ts.StartedAt AS SubscriptionStartDate,
        ts.ExpiresAt AS SubscriptionEndDate,
        ts.IsTrial,
        ts.Status AS SubscriptionStatus
    FROM Organizations o
    LEFT JOIN TenantSubscriptions ts ON o.OrganizationId = ts.OrganizationId
    LEFT JOIN SubscriptionPlans sp ON ts.PlanId = sp.PlanId
    WHERE o.OrganizationId = p_OrganizationId
      AND o.IsDeleted = 0
    ORDER BY ts.StartedAt DESC
    LIMIT 1;
END$$

DELIMITER ;