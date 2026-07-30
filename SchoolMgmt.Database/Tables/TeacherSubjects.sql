-- Table: TeacherSubjects
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `TeacherSubjects` (
  `TeacherSubjectId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `TeacherId` int NOT NULL,
  `ClassId` int NOT NULL,
  `SectionId` int DEFAULT NULL,
  `SubjectId` int NOT NULL,
  `IsPrimary` tinyint(1) DEFAULT '0',
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `TeacherSubjects`
  ADD PRIMARY KEY (`TeacherSubjectId`),
  ADD KEY `idx_teachersub_org` (`OrganizationId`),
  ADD KEY `idx_teachersub_teacher` (`TeacherId`),
  ADD KEY `idx_teachersub_class` (`ClassId`),
  ADD KEY `idx_teachersub_section` (`SectionId`),
  ADD KEY `idx_teachersub_subject` (`SubjectId`);

ALTER TABLE `TeacherSubjects`
  MODIFY `TeacherSubjectId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `TeacherSubjects`
  ADD CONSTRAINT `fk_ts_class` FOREIGN KEY (`ClassId`) REFERENCES `Classes` (`ClassId`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ts_section` FOREIGN KEY (`SectionId`) REFERENCES `Sections` (`SectionId`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ts_subject` FOREIGN KEY (`SubjectId`) REFERENCES `Subjects` (`SubjectId`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ts_teacher` FOREIGN KEY (`TeacherId`) REFERENCES `Teachers` (`TeacherId`) ON DELETE CASCADE;
