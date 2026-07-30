-- Procedure: sp_Admin_Parents_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Parents_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Parents_GetAll` (IN `p_OrgId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100))   BEGIN
    DECLARE v_Offset INT DEFAULT (p_PageNumber - 1) * p_PageSize;

    -- Main Data
    SELECT 
        p.ParentId,
        u.UserId,
        CONCAT(u.FirstName, ' ', u.LastName) AS FullName,
        u.Email,
        u.Phone,
        p.Occupation,
        p.Address,
        p.CreatedOn
    FROM Parents p
    INNER JOIN Users u ON p.UserId = u.UserId
    WHERE p.OrganizationId = p_OrgId
      AND p.IsDeleted = 0
      AND u.IsDeleted = 0
      AND (
            p_Search IS NULL OR p_Search = '' OR
            u.FirstName LIKE CONCAT('%', p_Search, '%') OR
            u.LastName LIKE CONCAT('%', p_Search, '%') OR
            u.Email LIKE CONCAT('%', p_Search, '%') OR
            u.Phone LIKE CONCAT('%', p_Search, '%')
          )
    ORDER BY p.ParentId DESC
    LIMIT v_Offset, p_PageSize;

    -- Total Count
    SELECT COUNT(*)
    FROM Parents p
    INNER JOIN Users u ON p.UserId = u.UserId
    WHERE p.OrganizationId = p_OrgId
      AND p.IsDeleted = 0
      AND u.IsDeleted = 0
      AND (
            p_Search IS NULL OR p_Search = '' OR
            u.FirstName LIKE CONCAT('%', p_Search, '%') OR
            u.LastName LIKE CONCAT('%', p_Search, '%') OR
            u.Email LIKE CONCAT('%', p_Search, '%') OR
            u.Phone LIKE CONCAT('%', p_Search, '%')
          );
END$$

DELIMITER ;