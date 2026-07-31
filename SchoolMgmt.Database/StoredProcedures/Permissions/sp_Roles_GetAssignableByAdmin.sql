-- Procedure: sp_Roles_GetAssignableByAdmin
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Roles_GetAssignableByAdmin`;

DELIMITER $$

CREATE PROCEDURE `sp_Roles_GetAssignableByAdmin` (IN `p_AdminId` INT)   BEGIN
    SELECT r.RoleId, r.RoleName
    FROM Roles r
    WHERE r.IsDeleted = 0
      AND r.RoleId IN (
          SELECT DISTINCT AllowedRoleId
          FROM AdminRoleScope
          WHERE AdminUserId = p_AdminId
      )
    ORDER BY r.RoleName;
END$$

DELIMITER ;