-- Procedure: sp_RefreshToken_Revoke
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_RefreshToken_Revoke`;

DELIMITER $$

CREATE PROCEDURE `sp_RefreshToken_Revoke` (IN `p_Token` VARCHAR(255), IN `p_RevokedAt` DATETIME, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE RefreshTokens
    SET RevokedAt = p_RevokedAt, ModifiedBy = p_ModifiedBy
    WHERE Token = p_Token;
END$$

DELIMITER ;