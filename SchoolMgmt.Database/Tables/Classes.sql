-- Table: Classes
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Classes` (
  `ClassId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `ClassName` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Section` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ClassTeacherId` int DEFAULT NULL,
  `AcademicYear` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OrderNo` int DEFAULT '0',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedBy` int DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Classes`
  ADD PRIMARY KEY (`ClassId`),
  ADD KEY `ClassTeacherId` (`ClassTeacherId`),
  ADD KEY `idx_classes_org` (`OrganizationId`);

ALTER TABLE `Classes`
  MODIFY `ClassId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Classes`
  ADD CONSTRAINT `Classes_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Classes_ibfk_2` FOREIGN KEY (`ClassTeacherId`) REFERENCES `Teachers` (`TeacherId`);
