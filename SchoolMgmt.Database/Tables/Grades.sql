-- Table: Grades
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Grades` (
  `GradeId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `CourseId` int NOT NULL,
  `ExamType` enum('Midterm','Final','Quiz','Assignment') COLLATE utf8mb4_general_ci NOT NULL,
  `MarksObtained` decimal(5,2) DEFAULT NULL,
  `MaxMarks` decimal(5,2) DEFAULT NULL,
  `Grade` varchar(5) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Grades`
  ADD PRIMARY KEY (`GradeId`),
  ADD KEY `StudentId` (`StudentId`),
  ADD KEY `CourseId` (`CourseId`),
  ADD KEY `idx_grades_org` (`OrganizationId`);

ALTER TABLE `Grades`
  MODIFY `GradeId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Grades`
  ADD CONSTRAINT `Grades_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Grades_ibfk_2` FOREIGN KEY (`StudentId`) REFERENCES `Students` (`StudentId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Grades_ibfk_3` FOREIGN KEY (`CourseId`) REFERENCES `Courses` (`CourseId`);
