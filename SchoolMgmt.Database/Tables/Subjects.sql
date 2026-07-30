-- Table: Subjects
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Subjects` (
  `SubjectId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `SubjectName` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `SubjectCode` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Description` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Subjects`
  ADD PRIMARY KEY (`SubjectId`),
  ADD UNIQUE KEY `uq_subject_org_name` (`OrganizationId`,`SubjectName`),
  ADD KEY `idx_subjects_org` (`OrganizationId`);

ALTER TABLE `Subjects`
  MODIFY `SubjectId` int NOT NULL AUTO_INCREMENT;
