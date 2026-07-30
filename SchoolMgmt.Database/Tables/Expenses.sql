-- Table: Expenses
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Expenses` (
  `ExpenseId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `ExpenseType` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `ExpenseDate` date DEFAULT NULL,
  `EnteredBy` int DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Expenses`
  ADD PRIMARY KEY (`ExpenseId`),
  ADD KEY `EnteredBy` (`EnteredBy`),
  ADD KEY `idx_expenses_org` (`OrganizationId`);

ALTER TABLE `Expenses`
  MODIFY `ExpenseId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Expenses`
  ADD CONSTRAINT `Expenses_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Expenses_ibfk_2` FOREIGN KEY (`EnteredBy`) REFERENCES `Users` (`UserId`);
