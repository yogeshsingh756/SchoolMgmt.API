-- Table: Parents
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Parents` (
  `ParentId` int NOT NULL,
  `UserId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `Occupation` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Parents`
  ADD PRIMARY KEY (`ParentId`),
  ADD KEY `UserId` (`UserId`),
  ADD KEY `idx_parents_org` (`OrganizationId`);

ALTER TABLE `Parents`
  MODIFY `ParentId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Parents`
  ADD CONSTRAINT `Parents_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Parents_ibfk_2` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE;
