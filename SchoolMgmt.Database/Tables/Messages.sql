-- Table: Messages
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Messages` (
  `MessageId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `SenderId` int NOT NULL,
  `ReceiverId` int NOT NULL,
  `Subject` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MessageBody` text COLLATE utf8mb4_general_ci,
  `SentOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `IsRead` tinyint(1) DEFAULT '0',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Messages`
  ADD PRIMARY KEY (`MessageId`),
  ADD KEY `SenderId` (`SenderId`),
  ADD KEY `ReceiverId` (`ReceiverId`),
  ADD KEY `idx_messages_org` (`OrganizationId`);

ALTER TABLE `Messages`
  MODIFY `MessageId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Messages`
  ADD CONSTRAINT `Messages_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Messages_ibfk_2` FOREIGN KEY (`SenderId`) REFERENCES `Users` (`UserId`),
  ADD CONSTRAINT `Messages_ibfk_3` FOREIGN KEY (`ReceiverId`) REFERENCES `Users` (`UserId`);
