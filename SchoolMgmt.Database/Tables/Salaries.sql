-- Table: Salaries
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Salaries` (
  `SalaryId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `TeacherId` int NOT NULL,
  `Month` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Year` int DEFAULT NULL,
  `BaseSalary` decimal(10,2) DEFAULT NULL,
  `Bonus` decimal(10,2) DEFAULT NULL,
  `Deductions` decimal(10,2) DEFAULT NULL,
  `NetPay` decimal(10,2) DEFAULT NULL,
  `PaidOn` date DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Salaries`
  ADD PRIMARY KEY (`SalaryId`),
  ADD KEY `TeacherId` (`TeacherId`),
  ADD KEY `idx_salaries_org` (`OrganizationId`);

ALTER TABLE `Salaries`
  MODIFY `SalaryId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Salaries`
  ADD CONSTRAINT `Salaries_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Salaries_ibfk_2` FOREIGN KEY (`TeacherId`) REFERENCES `Teachers` (`TeacherId`);
