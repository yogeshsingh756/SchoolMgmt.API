-- Procedure: sp_SuperAdmin_Analytics_GetOverview
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_SuperAdmin_Analytics_GetOverview`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_SuperAdmin_Analytics_GetOverview` ()   BEGIN
  SELECT 
    (SELECT COUNT(*) FROM Organizations) AS TotalTenants,
    (SELECT COUNT(*) FROM Organizations WHERE IsActive = 1 AND IsDeleted = 0) AS ActiveTenants,
    (SELECT COUNT(*) FROM Organizations WHERE IsActive = 0 AND IsDeleted = 1) AS InactiveTenants,
    (SELECT COUNT(*) FROM Users WHERE IsDeleted = 0) AS TotalUsers,
    (SELECT COUNT(*) FROM TenantSubscriptions WHERE STATUS = 'Active' AND IsDeleted = 0) AS ActiveSubscriptions,
    (SELECT COUNT(*) FROM TenantSubscriptions WHERE STATUS = 'Expired' AND IsDeleted = 0) AS ExpiredSubscriptions;
END$$

DELIMITER ;