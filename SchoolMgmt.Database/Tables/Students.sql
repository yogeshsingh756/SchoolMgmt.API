-- Table: Students
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Students` (
  `StudentId` int NOT NULL,
  `UserId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `AdmissionNo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `AdmissionDate` date DEFAULT NULL,
  `ParentId` int DEFAULT NULL,
  `CurrentClassId` int DEFAULT NULL,
  `CurrentSectionId` int DEFAULT NULL,
  `StudentType` enum('Regular','Private') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Regular',
  `Status` enum('Active','Graduated','Left') COLLATE utf8mb4_general_ci DEFAULT 'Active',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `MotherName` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `FatherName` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Students`
  ADD PRIMARY KEY (`StudentId`),
  ADD UNIQUE KEY `uq_admission_org` (`OrganizationId`,`AdmissionNo`),
  ADD KEY `UserId` (`UserId`),
  ADD KEY `ParentId` (`ParentId`),
  ADD KEY `CurrentClassId` (`CurrentClassId`),
  ADD KEY `idx_students_section` (`CurrentSectionId`),
  ADD KEY `idx_students_org` (`OrganizationId`),
  ADD KEY `idx_students_org_class` (`OrganizationId`,`CurrentClassId`);

ALTER TABLE `Students`
  MODIFY `StudentId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Students`
  ADD CONSTRAINT `Students_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Students_ibfk_3` FOREIGN KEY (`CurrentClassId`) REFERENCES `Classes` (`ClassId`),
  ADD CONSTRAINT `Students_ibfk_4` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_students_section` FOREIGN KEY (`CurrentSectionId`) REFERENCES `Sections` (`SectionId`) ON DELETE SET NULL;
