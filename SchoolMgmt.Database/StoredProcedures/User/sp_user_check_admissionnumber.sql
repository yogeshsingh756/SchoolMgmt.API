-- Procedure: sp_user_check_admissionnumber
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_user_check_admissionnumber`;

DELIMITER $$

CREATE PROCEDURE `sp_user_check_admissionnumber` (IN `p_OrganizationId` INT, IN `p_AdmNo` VARCHAR(50))   exit_block: BEGIN
    DECLARE v_Flag INT DEFAULT 0;

    IF p_AdmNo IS NULL OR TRIM(p_AdmNo) = '' THEN
        SELECT 0 AS ExistsFlag;
        LEAVE exit_block;
    END IF;

    SELECT COUNT(*) INTO v_Flag
    FROM Students s
    INNER JOIN Users u ON u.UserId = s.UserId AND u.OrganizationId = s.OrganizationId
    INNER JOIN Roles r ON r.RoleId = u.RoleId
    WHERE s.OrganizationId = p_OrganizationId
      AND IFNULL(u.IsDeleted,0) = 0
      AND u.IsActive = 1
      AND r.RoleName = 'Student'
      AND s.AdmissionNo = p_AdmNo
    LIMIT 1;

    SELECT (v_Flag > 0) AS ExistsFlag;
END$$

DELIMITER ;