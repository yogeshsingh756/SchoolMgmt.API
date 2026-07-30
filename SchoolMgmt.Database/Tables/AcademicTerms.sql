-- Table: AcademicTerms
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `AcademicTerms` (
  `TermId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `TermName` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `StartMonth` int DEFAULT NULL,
  `EndMonth` int DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `AcademicTerms`
  ADD PRIMARY KEY (`TermId`),
  ADD KEY `OrganizationId` (`OrganizationId`);

ALTER TABLE `AcademicTerms`
  MODIFY `TermId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `AcademicTerms`
  ADD CONSTRAINT `AcademicTerms_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`);
