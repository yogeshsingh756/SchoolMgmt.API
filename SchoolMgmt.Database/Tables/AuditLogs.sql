-- Table: AuditLogs
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `AuditLogs` (
  `LogId` int NOT NULL,
  `ActorUserId` int DEFAULT NULL,
  `OrganizationId` int DEFAULT NULL,
  `UserId` int DEFAULT NULL,
  `EntityName` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ActionType` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EntityKey` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Description` text COLLATE utf8mb4_general_ci,
  `OldValue` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `NewValue` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `IpAddress` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `UserAgent` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Action` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TargetType` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TargetId` int DEFAULT NULL,
  `Message` text COLLATE utf8mb4_general_ci,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP
) ;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `AuditLogs`
  ADD PRIMARY KEY (`LogId`),
  ADD KEY `FK_AuditLogs_Organizations` (`OrganizationId`),
  ADD KEY `FK_AuditLogs_Users` (`UserId`);

ALTER TABLE `AuditLogs`
  MODIFY `LogId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `AuditLogs`
  ADD CONSTRAINT `FK_AuditLogs_Organizations` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`),
  ADD CONSTRAINT `FK_AuditLogs_Users` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);
