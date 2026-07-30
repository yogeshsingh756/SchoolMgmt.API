-- Procedure: sp_Tenant_UpdateStatus
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Tenant_UpdateStatus`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Tenant_UpdateStatus` (IN `p_OrganizationId` INT, IN `p_TenantStatus` ENUM('Pending','Active','Blocked'), IN `p_ModifiedBy` INT)   BEGIN
    -- ✅ Update tenant record
    UPDATE Organizations
    SET 
        TenantStatus = p_TenantStatus,
        IsActive = CASE 
                      WHEN p_TenantStatus = 'Active' THEN 1
                      ELSE 0
                   END,
        IsDeleted = CASE 
                      WHEN p_TenantStatus = 'Blocked' THEN 1
                      ELSE 0
                   END,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE OrganizationId = p_OrganizationId;

    -- ✅ Log the status update into UserActivityLogs (tenant-aware)
    INSERT INTO UserActivityLogs (
        OrganizationId,
        UserId,
        ActionType,
        EntityName,
        EntityId,
        Description,
        IpAddress,
        ActionDate,
        CreatedOn
    )
    VALUES (
        p_OrganizationId,
        p_ModifiedBy,
        'UPDATE',
        'Organization',
        p_OrganizationId,
        CONCAT('Tenant status changed to ', p_TenantStatus),
        'SYSTEM',
        NOW(),
        NOW()
    );
END$$

DELIMITER ;