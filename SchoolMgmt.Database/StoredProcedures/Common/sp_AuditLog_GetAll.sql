-- Procedure: sp_AuditLog_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_AuditLog_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_AuditLog_GetAll` (IN `p_OrganizationId` INT, IN `p_SearchText` VARCHAR(100))   BEGIN
    SELECT 
        al.AuditLogId,
        al.OrganizationId,
        o.SchoolName AS OrganizationName,
        al.UserId,
        CONCAT(u.FirstName, ' ', u.LastName) AS PerformedBy,
        al.EntityName,
        al.ActionType,
        al.Description,
        al.CreatedOn,
        al.IpAddress
    FROM AuditLogs al
    LEFT JOIN Organizations o ON al.OrganizationId = o.OrganizationId
    LEFT JOIN Users u ON al.UserId = u.UserId
    WHERE 
        (p_OrganizationId IS NULL OR al.OrganizationId = p_OrganizationId)
        AND (
            p_SearchText IS NULL 
            OR al.EntityName LIKE CONCAT('%', p_SearchText, '%')
            OR al.ActionType LIKE CONCAT('%', p_SearchText, '%')
            OR al.Description LIKE CONCAT('%', p_SearchText, '%')
        )
    ORDER BY al.CreatedOn DESC;
END$$

DELIMITER ;