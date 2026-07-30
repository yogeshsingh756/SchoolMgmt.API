-- Table: Courses
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Courses` (
  `CourseId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `CourseName` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `CourseCode` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Courses`
  ADD PRIMARY KEY (`CourseId`),
  ADD KEY `idx_courses_org` (`OrganizationId`);

ALTER TABLE `Courses`
  MODIFY `CourseId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Courses`
  ADD CONSTRAINT `Courses_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE;
