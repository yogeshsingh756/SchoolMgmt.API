-- Procedure: sp_user_check_email
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_user_check_email`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_user_check_email` (IN `p_OrganizationId` INT, IN `p_Email` VARCHAR(100))   exit_block: BEGIN
    DECLARE v_Flag INT DEFAULT 0;

    IF p_Email IS NULL OR TRIM(p_Email) = '' THEN
        SELECT 0 AS ExistsFlag;
        LEAVE exit_block;
    END IF;

    SELECT COUNT(*) INTO v_Flag
    FROM Users u
    -- WHERE u.OrganizationId = p_OrganizationId
      WHERE IFNULL(u.IsDeleted,0) = 0
      AND u.Email = p_Email
    LIMIT 1;

    SELECT (v_Flag > 0) AS ExistsFlag;
END$$

DELIMITER ;