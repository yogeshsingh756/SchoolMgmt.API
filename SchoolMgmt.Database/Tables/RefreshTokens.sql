-- Table: RefreshTokens
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `RefreshTokens` (
  `RefreshTokenId` bigint NOT NULL,
  `OrganizationId` int NOT NULL,
  `UserId` int NOT NULL,
  `Token` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `ExpiresAt` datetime NOT NULL,
  `RevokedAt` datetime DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `RefreshTokens`
  ADD PRIMARY KEY (`RefreshTokenId`),
  ADD UNIQUE KEY `Token` (`Token`),
  ADD KEY `fk_rt_user` (`UserId`),
  ADD KEY `idx_rt_org_user` (`OrganizationId`,`UserId`);

ALTER TABLE `RefreshTokens`
  MODIFY `RefreshTokenId` bigint NOT NULL AUTO_INCREMENT;

ALTER TABLE `RefreshTokens`
  ADD CONSTRAINT `fk_rt_org` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rt_user` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE;
