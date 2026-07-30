-- Table: Attendance
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Attendance` (
  `AttendanceId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `StudentId` int DEFAULT NULL,
  `ClassId` int DEFAULT NULL,
  `Date` date NOT NULL,
  `Status` enum('Present','Absent','Late','Excused') COLLATE utf8mb4_general_ci NOT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Attendance`
  ADD PRIMARY KEY (`AttendanceId`),
  ADD KEY `StudentId` (`StudentId`),
  ADD KEY `ClassId` (`ClassId`),
  ADD KEY `idx_attendance_org` (`OrganizationId`);

ALTER TABLE `Attendance`
  MODIFY `AttendanceId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Attendance`
  ADD CONSTRAINT `Attendance_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Attendance_ibfk_2` FOREIGN KEY (`StudentId`) REFERENCES `Students` (`StudentId`),
  ADD CONSTRAINT `Attendance_ibfk_3` FOREIGN KEY (`ClassId`) REFERENCES `Classes` (`ClassId`);
