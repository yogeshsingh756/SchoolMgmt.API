-- Procedure: sp_Admin_Parent_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Parent_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Parent_GetById` (IN `p_OrganizationId` INT, IN `p_ParentUserId` INT)   BEGIN
    /*
      Returns parent info ready for edit binding.
      Mirrors style of sp_Admin_Student_GetById.
    */

    SELECT
        u.UserId                  AS ParentUserId,
        p.ParentId                AS ParentId,
        u.OrganizationId,

        u.FirstName               AS ParentFirstName,
        u.LastName                AS ParentLastName,
        u.Username                AS ParentUsername,
        u.Email                   AS ParentEmail,
        u.Phone                   AS ParentPhoneNumber,

        p.Occupation              AS Occupation,

        -- Address comes from Users table (you confirmed Users.Address exists)
        u.Address                 AS Address,

        -- metadata
        u.IsActive                AS IsActive,
        u.CreatedOn               AS CreatedOn,
        u.ModifiedOn              AS ModifiedOn,
        u.CreatedBy               AS CreatedBy,
        u.ModifiedBy              AS ModifiedBy

    FROM Users u
        INNER JOIN Roles r
            ON r.RoleId = u.RoleId
           AND r.RoleName = 'Parent'
        INNER JOIN Parents p
            ON p.UserId = u.UserId
           AND p.OrganizationId = u.OrganizationId

    WHERE
        u.OrganizationId = p_OrganizationId
        AND u.UserId = p_ParentUserId
        AND IFNULL(u.IsDeleted, 0) = 0
    LIMIT 1;
END$$

DELIMITER ;