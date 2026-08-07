-- Procedure: sp_Admin_Student_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Student_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Student_GetById` (IN `p_OrganizationId` INT, IN `p_StudentUserId` INT)   BEGIN
    /*
      Returns student info ONLY + ParentId for dropdown.
    */

    SELECT
        u.UserId              AS StudentUserId,
        s.StudentId           AS StudentId,
        u.OrganizationId,

        u.FirstName           AS StudentFirstName,
        u.LastName            AS StudentLastName,
        u.Username            AS StudentUsername,
        u.Email               AS StudentEmail,
        u.Phone               AS StudentPhoneNumber,
        
        u.Gender              AS Gender,        --  NEW
        u.Category            AS Category,      --  NEW

        s.MotherName          AS MotherName,    --  NEW
        s.FatherName          AS FatherName,    --  NEW

        s.AdmissionNo,
        s.AdmissionDate,
        s.CurrentClassId      AS ClassId,
        c.ClassName,
        s.CurrentSectionId    AS SectionId,
        sec.SectionName,
        s.StudentType,

        -- for parent dropdown binding
        -- s.ParentId            AS ParentId,
        u.Address

    FROM Users u
        INNER JOIN Roles r
            ON r.RoleId = u.RoleId
           AND r.RoleName = 'Student'
        INNER JOIN Students s
            ON s.UserId = u.UserId
           AND s.OrganizationId = u.OrganizationId
        LEFT JOIN Classes c
            ON c.ClassId = s.CurrentClassId
           AND c.OrganizationId = u.OrganizationId
        LEFT JOIN Sections sec
            ON sec.SectionId = s.CurrentSectionId
           AND sec.OrganizationId = u.OrganizationId

    WHERE
        u.OrganizationId = p_OrganizationId
        AND u.UserId = p_StudentUserId
        AND IFNULL(u.IsDeleted, 0) = 0
        AND u.IsActive = 1
    LIMIT 1;
END$$

DELIMITER ;