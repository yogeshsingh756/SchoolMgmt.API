-- Table: FeeTypes
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `FeeTypes` (
  `FeeTypeId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `FeeTypeName` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `FeeTypes`
  ADD PRIMARY KEY (`FeeTypeId`),
  ADD KEY `OrganizationId` (`OrganizationId`);

ALTER TABLE `FeeTypes`
  MODIFY `FeeTypeId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `FeeTypes`
  ADD CONSTRAINT `FeeTypes_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`);
