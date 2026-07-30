-- Procedure: sp_user_check_username
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_user_check_username`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_user_check_username` (IN `p_OrganizationId` INT, IN `p_UserName` VARCHAR(50))   exit_block: BEGIN
    DECLARE v_Flag INT DEFAULT 0;

    IF p_UserName IS NULL OR TRIM(p_UserName) = '' THEN
        SELECT 0 AS ExistsFlag;
        LEAVE exit_block;
    END IF;

    SELECT COUNT(*) INTO v_Flag
    FROM Users u
    -- WHERE u.OrganizationId = p_OrganizationId
      WHERE IFNULL(u.IsDeleted,0) = 0
      AND LOWER(u.Username) = LOWER(p_UserName)
    LIMIT 1;

    SELECT (v_Flag > 0) AS ExistsFlag;
END$$

DELIMITER ;