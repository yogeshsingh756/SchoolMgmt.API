-- Procedure: sp_Tenant_GetDetailById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Tenant_GetDetailById`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Tenant_GetDetailById` (IN `p_OrganizationId` INT)   BEGIN
  SELECT 
    o.OrganizationId,
    o.SchoolName,
    o.Email,
    o.Phone,
    s.PlanId,
    p.PlanName,
    s.StartedAt,
    s.ExpiresAt,
    s.STATUS AS SubscriptionStatus,
    o.IsActive,
    (SELECT COUNT(*) FROM Users u WHERE u.OrganizationId = o.OrganizationId AND u.IsDeleted = 0) AS UserCount
  FROM Organizations o
  LEFT JOIN TenantSubscriptions s ON o.OrganizationId = s.OrganizationId
  LEFT JOIN SubscriptionPlans p ON s.PlanId = p.PlanId
  WHERE o.OrganizationId = p_OrganizationId AND o.IsDeleted = 0
  LIMIT 1;
END$$

DELIMITER ;