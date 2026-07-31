-- Procedure: sp_Admin_Students_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Students_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Students_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100), IN `p_IsDropdown` INT)   BEGIN

    DECLARE v_Offset INT;
    DECLARE v_PageNumber INT;
    DECLARE v_PageSize INT;


    SET v_PageNumber = IFNULL(p_PageNumber, 1);
    SET v_PageSize   = IFNULL(p_PageSize, 10);
    SET v_Offset     = (v_PageNumber - 1) * v_PageSize;
    SET p_IsDropdown = IFNULL(p_IsDropdown, 0);  
IF p_IsDropdown = 1 THEN

        SELECT
            s.StudentId,
        s.AdmissionNo,
        s.AdmissionDate,
        s.ParentId,
        s.CurrentClassId,
        s.Status AS StudentStatus,
        u.UserId,
        u.FirstName,
        u.LastName,
        CONCAT(u.FirstName, ' ', u.LastName) AS StudentName,
        u.Email,
        u.Phone,
        u.Gender,
        u.DateOfBirth,
        u.Username,
        u.IsActive,
        u.Address,
        s.CreatedOn,
        s.ModifiedOn
        FROM Students s
        INNER JOIN Users u ON u.UserId = s.UserId
        WHERE 
            s.OrganizationId = p_OrganizationId
            AND s.IsDeleted = 0
            AND u.IsDeleted = 0

        ORDER BY s.StudentId DESC;

    ELSE

    SELECT
        s.StudentId,
        s.AdmissionNo,
        s.AdmissionDate,
        s.ParentId,
        s.CurrentClassId,
        s.Status AS StudentStatus,
        u.UserId,
        u.FirstName,
        u.LastName,
        CONCAT(u.FirstName, ' ', u.LastName) AS StudentName,
        u.Email,
        u.Phone,
        u.Gender,
        u.DateOfBirth,
        u.Username,
        u.IsActive,
        u.Address,
        s.CreatedOn,
        s.ModifiedOn
    FROM Students s
    INNER JOIN Users u ON u.UserId = s.UserId
    WHERE 
        s.OrganizationId = p_OrganizationId
        AND s.IsDeleted = 0
        AND u.IsDeleted = 0
        AND (
            p_Search IS NULL OR p_Search = '' 
            OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%')
            OR u.FirstName LIKE CONCAT('%', p_Search, '%')
            OR u.LastName LIKE CONCAT('%', p_Search, '%')
            OR u.Username LIKE CONCAT('%', p_Search, '%')
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR u.Phone LIKE CONCAT('%', p_Search, '%')
        )
    ORDER BY s.StudentId DESC
    LIMIT v_Offset, v_PageSize;


    SELECT COUNT(*) AS TotalRecords
    FROM Students s
    INNER JOIN Users u ON u.UserId = s.UserId
    WHERE 
        s.OrganizationId = p_OrganizationId
        AND s.IsDeleted = 0
        AND u.IsDeleted = 0
        AND (
            p_Search IS NULL OR p_Search = '' 
            OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%')
            OR u.FirstName LIKE CONCAT('%', p_Search, '%')
            OR u.LastName LIKE CONCAT('%', p_Search, '%')
            OR u.Username LIKE CONCAT('%', p_Search, '%')
            OR u.Email LIKE CONCAT('%', p_Search, '%')
            OR u.Phone LIKE CONCAT('%', p_Search, '%')
        );
        
    END IF;

END$$

DELIMITER ;