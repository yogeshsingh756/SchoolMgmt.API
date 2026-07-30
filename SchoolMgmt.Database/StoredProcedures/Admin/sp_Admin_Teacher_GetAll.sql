-- Procedure: sp_Admin_Teacher_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Teacher_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Teacher_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100), IN `p_StatusFilter` VARCHAR(10))   BEGIN
    DECLARE v_Offset INT DEFAULT (p_PageNumber - 1) * p_PageSize;

    -- Result set: teacher users (paged)
    SELECT 
        u.UserId,
        t.TeacherId,
        CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS FullName,
        u.Username,
        u.Email,
        u.Phone,
        u.Address,                                      -- use Users.Address
        r.RoleName,
        CASE WHEN u.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS STATUS,
        u.CreatedOn,
        COALESCE(u.ModifiedOn, u.CreatedOn) AS LastModified,
        COALESCE(CONCAT(mu.FirstName, ' ', mu.LastName), 'System') AS ModifiedByName,

        -- Teacher-specific fields
        t.Qualification,
        t.Designation,
        t.Salary

    FROM Users u
        INNER JOIN Roles r ON u.RoleId = r.RoleId
        LEFT JOIN Users mu ON u.ModifiedBy = mu.UserId
        LEFT JOIN Teachers t ON t.UserId = u.UserId AND t.OrganizationId = u.OrganizationId

    WHERE 
        u.OrganizationId = p_OrganizationId
        AND IFNULL(u.IsDeleted,0) = 0
        AND r.RoleName = 'Teacher'
        AND (
            p_Search IS NULL 
            OR p_Search = '' 
            OR u.Username LIKE CONCAT('%', p_Search, '%') 
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR CONCAT(u.FirstName, ' ', u.LastName) LIKE CONCAT('%', p_Search, '%')
            OR t.Qualification LIKE CONCAT('%', p_Search, '%')
            OR t.Designation LIKE CONCAT('%', p_Search, '%')
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
        LEFT JOIN Teachers t ON t.UserId = u.UserId AND t.OrganizationId = u.OrganizationId
    WHERE 
        u.OrganizationId = p_OrganizationId
        AND IFNULL(u.IsDeleted,0) = 0
        AND r.RoleName = 'Teacher'
        AND (
            p_Search IS NULL 
            OR p_Search = '' 
            OR u.Username LIKE CONCAT('%', p_Search, '%') 
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR CONCAT(u.FirstName, ' ', u.LastName) LIKE CONCAT('%', p_Search, '%')
            OR t.Qualification LIKE CONCAT('%', p_Search, '%')
            OR t.Designation LIKE CONCAT('%', p_Search, '%')
        )
        AND (
            p_StatusFilter IS NULL
            OR p_StatusFilter = ''
            OR (p_StatusFilter = 'Active' AND u.IsActive = 1)
            OR (p_StatusFilter = 'Inactive' AND u.IsActive = 0)
        );

END$$

DELIMITER ;