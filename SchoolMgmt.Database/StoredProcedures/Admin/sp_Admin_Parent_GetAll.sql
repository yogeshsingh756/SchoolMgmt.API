-- Procedure: sp_Admin_Parent_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Parent_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Parent_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100), IN `p_StatusFilter` VARCHAR(10))   BEGIN
    DECLARE v_Offset INT DEFAULT (p_PageNumber - 1) * p_PageSize;

    -- Result set: parent users (paged)
    SELECT 
        u.UserId,
        p.ParentId,
        CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS FullName,
        u.Username,
        u.Email,
        u.Phone,
        COALESCE(u.Address, NULL) AS Address,      -- CHANGED: use Users.Address only
        r.RoleName,
        CASE WHEN u.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS STATUS,
        u.CreatedOn,
        COALESCE(u.ModifiedOn, u.CreatedOn) AS LastModified,
        COALESCE(CONCAT(mu.FirstName, ' ', mu.LastName), 'System') AS ModifiedByName,

        -- Parent-specific fields
        p.Occupation
        -- NOTE: Parents.Address removed because Parents table does not have Address column.  -- CHANGED

    FROM Users u
        INNER JOIN Roles r ON u.RoleId = r.RoleId
        LEFT JOIN Users mu ON u.ModifiedBy = mu.UserId
        LEFT JOIN Parents p ON p.UserId = u.UserId AND p.OrganizationId = u.OrganizationId

    WHERE 
        u.OrganizationId = p_OrganizationId
        AND IFNULL(u.IsDeleted,0) = 0
        AND r.RoleName = 'Parent'
        AND (
            p_Search IS NULL 
            OR p_Search = '' 
            OR u.Username LIKE CONCAT('%', p_Search, '%') 
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR CONCAT(u.FirstName, ' ', u.LastName) LIKE CONCAT('%', p_Search, '%')
            OR p.Occupation LIKE CONCAT('%', p_Search, '%')
            -- p.Address search removed because Parents.Address doesn't exist.  -- CHANGED
        )
        AND (
            p_StatusFilter IS NULL
            OR p_StatusFilter = ''
            OR (p_StatusFilter = 'Active' AND u.IsActive = 1)
            OR (p_StatusFilter = 'Inactive' AND u.IsActive = 0)
        )
    ORDER BY u.CreatedOn DESC
    LIMIT p_PageSize OFFSET v_Offset;

    -- Total count (for pagination)
    SELECT COUNT(*) AS TotalCount
    FROM Users u
        INNER JOIN Roles r ON u.RoleId = r.RoleId
        LEFT JOIN Parents p ON p.UserId = u.UserId AND p.OrganizationId = u.OrganizationId
    WHERE 
        u.OrganizationId = p_OrganizationId
        AND IFNULL(u.IsDeleted,0) = 0
        AND r.RoleName = 'Parent'
        AND (
            p_Search IS NULL 
            OR p_Search = '' 
            OR u.Username LIKE CONCAT('%', p_Search, '%') 
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR CONCAT(u.FirstName, ' ', u.LastName) LIKE CONCAT('%', p_Search, '%')
            OR p.Occupation LIKE CONCAT('%', p_Search, '%')
            -- p.Address predicate removed.  -- CHANGED
        )
        AND (
            p_StatusFilter IS NULL
            OR p_StatusFilter = ''
            OR (p_StatusFilter = 'Active' AND u.IsActive = 1)
            OR (p_StatusFilter = 'Inactive' AND u.IsActive = 0)
        );

END$$

DELIMITER ;