-- Procedure: sp_Teachers_GetByOrganization
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Teachers_GetByOrganization`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Teachers_GetByOrganization` (IN `p_OrganizationId` INT)   BEGIN
    SELECT 
        T.TeacherId,
        U.UserId,
        CONCAT(U.FirstName, ' ', U.LastName) AS TeacherName,
        U.Email,
        U.Phone AS PhoneNumber,
        T.Designation,
        T.Qualification,
        T.Salary,
        T.IsActive,
        T.CreatedOn
    FROM Teachers T
    INNER JOIN Users U ON T.UserId = U.UserId
    WHERE T.OrganizationId = p_OrganizationId
      AND T.IsDeleted = 0
      AND T.IsActive = 1
    ORDER BY TeacherName;
END$$

DELIMITER ;