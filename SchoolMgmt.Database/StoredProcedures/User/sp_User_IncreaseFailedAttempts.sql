-- Procedure: sp_User_IncreaseFailedAttempts
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_IncreaseFailedAttempts`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_User_IncreaseFailedAttempts` (IN `p_UserId` INT, IN `p_MaxFailed` INT, IN `p_LockoutMinutes` INT, OUT `o_FailedCount` INT, OUT `o_IsLocked` TINYINT(1))   BEGIN
  UPDATE Users SET FailedLoginAttempts = COALESCE(FailedLoginAttempts,0) + 1 WHERE UserId = p_UserId;
  SELECT FailedLoginAttempts INTO o_FailedCount FROM Users WHERE UserId = p_UserId;

  IF o_FailedCount >= p_MaxFailed THEN
    UPDATE Users SET LockoutUntil = DATE_ADD(NOW(), INTERVAL p_LockoutMinutes MINUTE) WHERE UserId = p_UserId;
    SET o_IsLocked = 1;
  ELSE
    SET o_IsLocked = 0;
  END IF;
END$$

DELIMITER ;