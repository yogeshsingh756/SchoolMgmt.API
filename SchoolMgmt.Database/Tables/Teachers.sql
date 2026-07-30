-- Table: Teachers
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Teachers` (
  `TeacherId` int NOT NULL,
  `UserId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `Qualification` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HireDate` date DEFAULT NULL,
  `Designation` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Teachers`
  ADD PRIMARY KEY (`TeacherId`),
  ADD KEY `UserId` (`UserId`),
  ADD KEY `idx_teachers_org` (`OrganizationId`);

ALTER TABLE `Teachers`
  MODIFY `TeacherId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Teachers`
  ADD CONSTRAINT `Teachers_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Teachers_ibfk_2` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE;
