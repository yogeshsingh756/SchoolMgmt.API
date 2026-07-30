-- Procedure: sp_User_ChangePassword
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_ChangePassword`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_User_ChangePassword` (IN `p_UserId` INT, IN `p_PasswordHash` VARCHAR(255), IN `p_ModifiedBy` INT)   BEGIN
  DECLARE v_exists INT DEFAULT 0;

  SELECT COUNT(*) INTO v_exists
  FROM Users
  WHERE UserId = p_UserId
    AND (IsDeleted = 0 OR IsDeleted IS NULL);

  IF v_exists = 0 THEN
    SELECT 0 AS SuccessFlag, 'User not found.' AS Message;
  ELSE
    UPDATE Users
    SET PasswordHash = p_PasswordHash,
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE UserId = p_UserId;

    SELECT 1 AS SuccessFlag, 'Password changed successfully.' AS Message;
  END IF;
END$$

DELIMITER ;