-- Procedure: sp_Auth_GetUserByUsername
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Auth_GetUserByUsername`;

DELIMITER $$

CREATE PROCEDURE `sp_Auth_GetUserByUsername` (IN `p_Username` VARCHAR(100))   BEGIN
  SELECT u.UserId, u.OrganizationId, u.RoleId, r.RoleName, u.FirstName, u.LastName, u.Email, u.Username, u.PasswordHash, u.IsActive, u.IsDeleted
  FROM Users u
  LEFT JOIN Roles r ON u.RoleId = r.RoleId
  WHERE u.Username = p_Username
  LIMIT 1;
END$$

DELIMITER ;