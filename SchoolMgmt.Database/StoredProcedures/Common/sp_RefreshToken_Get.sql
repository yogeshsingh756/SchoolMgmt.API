-- Procedure: sp_RefreshToken_Get
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_RefreshToken_Get`;

DELIMITER $$

CREATE PROCEDURE `sp_RefreshToken_Get` (IN `p_Token` VARCHAR(255))   BEGIN
  SELECT RefreshTokenId, OrganizationId, UserId, Token, ExpiresAt, RevokedAt, IsDeleted
  FROM RefreshTokens
  WHERE Token = p_Token
  LIMIT 1;
END$$

DELIMITER ;