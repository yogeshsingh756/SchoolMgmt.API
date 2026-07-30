-- Procedure: sp_AdminRoleScope_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_AdminRoleScope_Upsert`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_AdminRoleScope_Upsert` (IN `p_AdminUserId` INT, IN `p_AllowedRoleIds` TEXT, IN `p_CreatedBy` INT)   BEGIN
    DECLARE v_Pos INT DEFAULT 0;
    DECLARE v_Value VARCHAR(10);
    DECLARE v_Str TEXT;

    -- Clean up previous scope
    DELETE FROM AdminRoleScope WHERE AdminUserId = p_AdminUserId;

    SET v_Str = p_AllowedRoleIds;

    -- Loop through comma-separated values
    WHILE LENGTH(v_Str) > 0 DO
        SET v_Pos = LOCATE(',', v_Str);

        IF v_Pos = 0 THEN
            SET v_Value = v_Str;
            SET v_Str = '';
        ELSE
            SET v_Value = SUBSTRING(v_Str, 1, v_Pos - 1);
            SET v_Str = SUBSTRING(v_Str, v_Pos + 1);
        END IF;

        IF TRIM(v_Value) <> '' THEN
            INSERT INTO AdminRoleScope (AdminUserId, AllowedRoleId, CreatedBy)
            VALUES (p_AdminUserId, CAST(v_Value AS UNSIGNED), p_CreatedBy);
        END IF;
    END WHILE;
END$$

DELIMITER ;