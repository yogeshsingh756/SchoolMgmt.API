-- Table: UserActivityLogs
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `UserActivityLogs` (
  `LogId` bigint NOT NULL,
  `OrganizationId` int NOT NULL,
  `UserId` int NOT NULL,
  `ActionType` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EntityName` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EntityId` int DEFAULT NULL,
  `Description` text COLLATE utf8mb4_general_ci,
  `ActionDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `IpAddress` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `UserActivityLogs`
  ADD PRIMARY KEY (`LogId`),
  ADD KEY `UserId` (`UserId`),
  ADD KEY `idx_logs_org_user` (`OrganizationId`,`UserId`);

ALTER TABLE `UserActivityLogs`
  MODIFY `LogId` bigint NOT NULL AUTO_INCREMENT;

ALTER TABLE `UserActivityLogs`
  ADD CONSTRAINT `UserActivityLogs_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `UserActivityLogs_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`);
