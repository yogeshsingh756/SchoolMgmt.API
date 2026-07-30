-- Table: Fees
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Fees` (
  `FeeId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `ClassId` int NOT NULL,
  `FeeType` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `DueDate` date DEFAULT NULL,
  `Status` enum('Pending','Paid','Overdue') COLLATE utf8mb4_general_ci DEFAULT 'Pending',
  `Term` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Session` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Fees`
  ADD PRIMARY KEY (`FeeId`),
  ADD KEY `ClassId` (`ClassId`),
  ADD KEY `idx_fees_org` (`OrganizationId`);

ALTER TABLE `Fees`
  MODIFY `FeeId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Fees`
  ADD CONSTRAINT `Fees_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Fees_ibfk_2` FOREIGN KEY (`ClassId`) REFERENCES `Classes` (`ClassId`);
