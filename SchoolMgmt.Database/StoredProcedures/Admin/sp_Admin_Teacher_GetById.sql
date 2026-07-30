-- Procedure: sp_Admin_Teacher_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Teacher_GetById`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Teacher_GetById` (IN `p_OrganizationId` INT, IN `p_TeacherUserId` INT)   BEGIN
    /*
      Returns teacher info ready for edit binding.
      Mirrors style of sp_Admin_Student_GetById / sp_Admin_Parent_GetById.
    */

    SELECT
        u.UserId                    AS TeacherUserId,
        t.TeacherId                 AS TeacherId,
        u.OrganizationId,

        u.FirstName                 AS TeacherFirstName,
        u.LastName                  AS TeacherLastName,
        u.Username                  AS TeacherUsername,
        u.Email                     AS TeacherEmail,
        u.Phone                     AS TeacherPhoneNumber,

        t.Qualification             AS Qualification,
        t.Designation               AS Designation,
        t.Salary                    AS Salary,

        -- Address comes from Users table
        u.Address                   AS Address,

        -- metadata
        u.IsActive                  AS IsActive,
        u.CreatedOn                 AS CreatedOn,
        u.ModifiedOn                AS ModifiedOn,
        u.CreatedBy                 AS CreatedBy,
        u.ModifiedBy                AS ModifiedBy

    FROM Users u
        INNER JOIN Roles r
            ON r.RoleId = u.RoleId
           AND r.RoleName = 'Teacher'
        INNER JOIN Teachers t
            ON t.UserId = u.UserId
           AND t.OrganizationId = u.OrganizationId

    WHERE
        u.OrganizationId = p_OrganizationId
        AND u.UserId = p_TeacherUserId
        AND IFNULL(u.IsDeleted, 0) = 0
    LIMIT 1;
END$$

DELIMITER ;