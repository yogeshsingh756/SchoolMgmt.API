-- Table: Enrollments
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Enrollments` (
  `EnrollmentId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `CourseId` int NOT NULL,
  `ClassId` int NOT NULL,
  `EnrollmentDate` date DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Enrollments`
  ADD PRIMARY KEY (`EnrollmentId`),
  ADD KEY `StudentId` (`StudentId`),
  ADD KEY `CourseId` (`CourseId`),
  ADD KEY `ClassId` (`ClassId`),
  ADD KEY `idx_enrollments_org` (`OrganizationId`);

ALTER TABLE `Enrollments`
  MODIFY `EnrollmentId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Enrollments`
  ADD CONSTRAINT `Enrollments_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Enrollments_ibfk_2` FOREIGN KEY (`StudentId`) REFERENCES `Students` (`StudentId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Enrollments_ibfk_3` FOREIGN KEY (`CourseId`) REFERENCES `Courses` (`CourseId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Enrollments_ibfk_4` FOREIGN KEY (`ClassId`) REFERENCES `Classes` (`ClassId`) ON DELETE CASCADE;
