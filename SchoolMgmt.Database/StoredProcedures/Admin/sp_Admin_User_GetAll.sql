-- Procedure: sp_Admin_User_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_User_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_User_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100), IN `p_StatusFilter` VARCHAR(10))   BEGIN
    DECLARE v_Offset INT DEFAULT (p_PageNumber - 1) * p_PageSize;

    SELECT 
        u.UserId,
        CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS FullName,
        u.FirstName,
        u.LastName,
        u.Username,
        u.Email,
        u.Phone,
        u.Address,
        r.RoleName,
        CASE 
            WHEN u.IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END AS STATUS,
        u.CreatedOn,
        COALESCE(u.ModifiedOn, u.CreatedOn) AS LastModified,
        COALESCE(CONCAT(mu.FirstName, ' ', mu.LastName), 'System') AS ModifiedByName,
        

        u.Gender,
        u.Category,

        -- Parent fields
        CASE WHEN r.RoleName = 'Parent' THEN p.Occupation ELSE NULL END AS Occupation,
        CASE WHEN r.RoleName = 'Parent' THEN p.Address ELSE NULL END AS Address,

        -- Teacher fields
        CASE WHEN r.RoleName = 'Teacher' THEN t.Qualification ELSE NULL END AS Qualification,
        CASE WHEN r.RoleName = 'Teacher' THEN t.Designation ELSE NULL END AS Designation,
        CASE WHEN r.RoleName = 'Teacher' THEN t.Salary ELSE NULL END AS Salary,


        CASE WHEN r.RoleName = 'Student' THEN s.AdmissionNo ELSE NULL END AS AdmissionNo,
        CASE WHEN r.RoleName = 'Student' THEN s.CurrentClassId ELSE NULL END AS CurrentClassId,


        CASE WHEN r.RoleName = 'Student' THEN c.ClassName ELSE NULL END AS ClassName,   -- CHANGED
        

        CASE WHEN r.RoleName = 'Student' THEN s.MotherName ELSE NULL END AS MotherName,
        CASE WHEN r.RoleName = 'Student' THEN s.FatherName ELSE NULL END AS FatherName

    FROM Users u
        LEFT JOIN Roles r ON u.RoleId = r.RoleId
        LEFT JOIN Users mu ON u.ModifiedBy = mu.UserId

 
        LEFT JOIN Parents p ON p.UserId = u.UserId AND p.OrganizationId = u.OrganizationId
        LEFT JOIN Teachers t ON t.UserId = u.UserId AND t.OrganizationId = u.OrganizationId
        LEFT JOIN Students s ON s.UserId = u.UserId AND s.OrganizationId = u.OrganizationId

       
        LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId AND c.OrganizationId = u.OrganizationId   

    WHERE 
        u.OrganizationId = p_OrganizationId
        AND IFNULL(u.IsDeleted,0) = 0
        AND (
            p_Search IS NULL 
            OR p_Search = '' 
            OR u.Username LIKE CONCAT('%', p_Search, '%') 
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR CONCAT(u.FirstName, ' ', u.LastName) LIKE CONCAT('%', p_Search, '%')
        )
        AND (
            p_StatusFilter IS NULL
            OR p_StatusFilter = ''
            OR (p_StatusFilter = 'Active' AND u.IsActive = 1)
            OR (p_StatusFilter = 'Inactive' AND u.IsActive = 0)
            OR r.RoleName LIKE CONCAT('%', p_StatusFilter, '%')
        )
    ORDER BY u.CreatedOn DESC
    LIMIT p_PageSize OFFSET v_Offset;

    -- Total count (unchanged)
    SELECT COUNT(*)
    FROM Users u
    LEFT JOIN Roles r ON u.RoleId = r.RoleId
    WHERE 
        u.OrganizationId = p_OrganizationId
        AND IFNULL(u.IsDeleted,0) = 0
        AND (
            p_Search IS NULL 
            OR p_Search = '' 
            OR u.Username LIKE CONCAT('%', p_Search, '%') 
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR CONCAT(u.FirstName, ' ', u.LastName) LIKE CONCAT('%', p_Search, '%')
        )
        AND (
            p_StatusFilter IS NULL
            OR p_StatusFilter = ''
            OR (p_StatusFilter = 'Active' AND u.IsActive = 1)
            OR (p_StatusFilter = 'Inactive' AND u.IsActive = 0)
            OR r.RoleName LIKE CONCAT('%', p_StatusFilter, '%')
        );
END$$

DELIMITER ;