-- Procedure: sp_RefreshToken_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_RefreshToken_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_RefreshToken_Create` (IN `p_OrganizationId` INT, IN `p_UserId` INT, IN `p_Token` VARCHAR(255), IN `p_ExpiresAt` DATETIME, IN `p_CreatedBy` INT, OUT `o_RefreshTokenId` BIGINT)   BEGIN
  INSERT INTO RefreshTokens (OrganizationId, UserId, Token, ExpiresAt, CreatedOn, ModifiedBy)
  VALUES (p_OrganizationId, p_UserId, p_Token, p_ExpiresAt, NOW(), p_CreatedBy);

  SET o_RefreshTokenId = LAST_INSERT_ID();
END$$

DELIMITER ;