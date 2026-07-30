-- Procedure: sp_Admin_Student_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Student_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Student_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100), IN `p_StatusFilter` VARCHAR(10), IN `p_IsDropdown` INT)   BEGIN
    --  DECLARE FIRST (MANDATORY)
    DECLARE v_Offset INT DEFAULT 0;

    --  NOW NULL HANDLING
    SET p_PageNumber   = IFNULL(p_PageNumber, 1);
    SET p_PageSize     = IFNULL(p_PageSize, 2);
    SET p_IsDropdown   = IFNULL(p_IsDropdown, 0);
    SET p_Search       = IFNULL(TRIM(p_Search), '');
    SET p_StatusFilter = IFNULL(TRIM(p_StatusFilter), '');

    SET v_Offset = (p_PageNumber - 1) * p_PageSize;
    IF p_IsDropdown = 1 THEN

        --  NO PAGINATION (ALL DATA)
        SELECT 
            u.UserId,
            CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS FullName,
            u.UserId,
    u.FirstName,         --  ADD THIS
    u.LastName,          --  ADD THIS
    u.IsActive,          --  ADD THIS
            u.Username,
            u.Email,
            u.Phone,
            u.Address,
            'Student' AS RoleName,
            
            CASE 
                WHEN u.IsActive = 1 THEN 'Active'
                ELSE 'Inactive'
            END AS StudentStatus,

            u.CreatedOn,
            COALESCE(u.ModifiedOn, u.CreatedOn) AS LastModified,
            COALESCE(CONCAT(mu.FirstName, ' ', mu.LastName), 'System') AS ModifiedByName,

            s.AdmissionNo,
            s.CurrentClassId,
            c.ClassName,
            u.Gender,
            u.Category,
            s.MotherName,
            s.FatherName

        FROM Users u
            INNER JOIN Roles r 
                ON u.RoleId = r.RoleId AND r.RoleName = 'Student'

            LEFT JOIN Users mu 
                ON u.ModifiedBy = mu.UserId

            INNER JOIN Students s 
                ON s.UserId = u.UserId AND s.OrganizationId = u.OrganizationId

            LEFT JOIN Classes c 
                ON c.ClassId = s.CurrentClassId AND c.OrganizationId = u.OrganizationId

        WHERE 
            u.OrganizationId = p_OrganizationId
            AND IFNULL(u.IsDeleted,0) = 0

        ORDER BY u.CreatedOn DESC;

    ELSE
    /* ============================
       MAIN PAGINATED RESULT SET
       ============================ */
    SELECT 
        u.UserId,
        CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS FullName,
        u.Username,
        u.Email,
        u.Phone,
        u.Address,
        'Student' AS RoleName,   -- fixed
        
        CASE 
            WHEN u.IsActive = 1 THEN 'Active'
            ELSE 'Inactive'
        END AS STATUS,

        u.CreatedOn,
        COALESCE(u.ModifiedOn, u.CreatedOn) AS LastModified,
        COALESCE(CONCAT(mu.FirstName, ' ', mu.LastName), 'System') AS ModifiedByName,

        -- Student fields only
        s.AdmissionNo,
        s.CurrentClassId,
        c.ClassName,
         -- NEW FIELDS ADDED
        u.Gender,
        u.Category,
        s.MotherName,
        s.FatherName

    FROM Users u
        INNER JOIN Roles r 
            ON u.RoleId = r.RoleId AND r.RoleName = 'Student'

        LEFT JOIN Users mu 
            ON u.ModifiedBy = mu.UserId

        INNER JOIN Students s 
            ON s.UserId = u.UserId AND s.OrganizationId = u.OrganizationId

        LEFT JOIN Classes c 
            ON c.ClassId = s.CurrentClassId AND c.OrganizationId = u.OrganizationId

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
        )
    ORDER BY u.CreatedOn DESC
    LIMIT p_PageSize OFFSET v_Offset;
    END IF;


    /* ============================
       TOTAL COUNT (FOR PAGINATION)
       ============================ */
    IF p_IsDropdown = 0 THEN
    SELECT COUNT(*)
    FROM Users u
        INNER JOIN Roles r 
            ON u.RoleId = r.RoleId AND r.RoleName = 'Student'
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
        );
        END IF;

END$$

DELIMITER ;