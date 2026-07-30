-- Procedure: sp_User_ResetFailedAttempts
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_ResetFailedAttempts`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_User_ResetFailedAttempts` (IN `p_UserId` INT)   BEGIN
  UPDATE Users SET FailedLoginAttempts = 0, LockoutUntil = NULL WHERE UserId = p_UserId;
END$$

DELIMITER ;