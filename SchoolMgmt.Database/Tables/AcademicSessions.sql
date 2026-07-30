-- Table: AcademicSessions
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `AcademicSessions` (
  `SessionId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `SessionName` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `AcademicSessions`
  ADD PRIMARY KEY (`SessionId`),
  ADD KEY `OrganizationId` (`OrganizationId`);

ALTER TABLE `AcademicSessions`
  MODIFY `SessionId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `AcademicSessions`
  ADD CONSTRAINT `AcademicSessions_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`);
