-- Table: Sections
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Sections` (
  `SectionId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `ClassId` int NOT NULL,
  `SectionName` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ClassTeacherId` int DEFAULT NULL,
  `Capacity` int DEFAULT '0',
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedBy` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Sections`
  ADD PRIMARY KEY (`SectionId`),
  ADD KEY `OrganizationId` (`OrganizationId`),
  ADD KEY `ClassId` (`ClassId`),
  ADD KEY `FK_Sections_Teachers` (`ClassTeacherId`);

ALTER TABLE `Sections`
  MODIFY `SectionId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Sections`
  ADD CONSTRAINT `FK_Sections_Teachers` FOREIGN KEY (`ClassTeacherId`) REFERENCES `Teachers` (`TeacherId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Sections_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`),
  ADD CONSTRAINT `Sections_ibfk_2` FOREIGN KEY (`ClassId`) REFERENCES `Classes` (`ClassId`);
