-- Table: ClassSubjects
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `ClassSubjects` (
  `ClassSubjectId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `ClassId` int NOT NULL,
  `SubjectId` int NOT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `ClassSubjects`
  ADD PRIMARY KEY (`ClassSubjectId`),
  ADD KEY `idx_classsubjects_org` (`OrganizationId`),
  ADD KEY `idx_classsubjects_class` (`ClassId`),
  ADD KEY `idx_classsubjects_subject` (`SubjectId`);

ALTER TABLE `ClassSubjects`
  MODIFY `ClassSubjectId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `ClassSubjects`
  ADD CONSTRAINT `fk_cs_class` FOREIGN KEY (`ClassId`) REFERENCES `Classes` (`ClassId`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cs_subject` FOREIGN KEY (`SubjectId`) REFERENCES `Subjects` (`SubjectId`) ON DELETE CASCADE;
