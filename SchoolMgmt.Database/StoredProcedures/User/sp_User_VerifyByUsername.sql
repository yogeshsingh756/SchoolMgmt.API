-- Procedure: sp_User_VerifyByUsername
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_VerifyByUsername`;

DELIMITER $$

CREATE PROCEDURE `sp_User_VerifyByUsername` (IN `p_Username` VARCHAR(100))   BEGIN
  SELECT u.UserId, u.OrganizationId, u.FirstName, u.LastName, u.Email, u.Username, u.IsActive
  FROM Users u
  WHERE (u.Username = p_Username OR u.Email = p_Username)
    AND (u.IsDeleted = 0 OR u.IsDeleted IS NULL)
  LIMIT 1;
END$$

DELIMITER ;