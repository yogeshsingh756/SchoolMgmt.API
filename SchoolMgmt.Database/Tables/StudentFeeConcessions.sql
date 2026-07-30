-- Table: StudentFeeConcessions
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `StudentFeeConcessions` (
  `ConcessionId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `FeeTypeId` int NOT NULL,
  `DiscountType` enum('Flat','Percent') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Flat',
  `DiscountValue` decimal(10,2) NOT NULL,
  `Remark` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedBy` int NOT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `StudentFeeConcessions`
  ADD PRIMARY KEY (`ConcessionId`),
  ADD UNIQUE KEY `uq_student_fee` (`OrganizationId`,`StudentId`,`FeeTypeId`,`IsDeleted`);

ALTER TABLE `StudentFeeConcessions`
  MODIFY `ConcessionId` int NOT NULL AUTO_INCREMENT;
