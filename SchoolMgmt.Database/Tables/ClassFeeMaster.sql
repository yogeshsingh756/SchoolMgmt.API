-- Table: ClassFeeMaster
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `ClassFeeMaster` (
  `ClassFeeId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `ClassId` int NOT NULL,
  `Section` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TermId` int DEFAULT NULL,
  `SessionId` int DEFAULT NULL,
  `FeeTypeId` int NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `DueDate` date DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedBy` int NOT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `ClassFeeMaster`
  ADD PRIMARY KEY (`ClassFeeId`),
  ADD KEY `ix_class` (`OrganizationId`,`ClassId`,`FeeTypeId`,`IsDeleted`);

ALTER TABLE `ClassFeeMaster`
  MODIFY `ClassFeeId` int NOT NULL AUTO_INCREMENT;
