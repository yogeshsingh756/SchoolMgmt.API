-- Table: FeePayments
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `FeePayments` (
  `PaymentId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `FeeId` int NOT NULL,
  `PaymentDate` date DEFAULT NULL,
  `AmountPaid` decimal(10,2) DEFAULT NULL,
  `PaymentMode` enum('Cash','Card','Online') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TransactionRef` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Remarks` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Status` enum('Pending','Paid','Overdue') COLLATE utf8mb4_general_ci DEFAULT 'Paid',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `FeePayments`
  ADD PRIMARY KEY (`PaymentId`),
  ADD KEY `StudentId` (`StudentId`),
  ADD KEY `FeeId` (`FeeId`),
  ADD KEY `idx_fee_payments_org` (`OrganizationId`);

ALTER TABLE `FeePayments`
  MODIFY `PaymentId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `FeePayments`
  ADD CONSTRAINT `FeePayments_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `FeePayments_ibfk_2` FOREIGN KEY (`StudentId`) REFERENCES `Students` (`StudentId`),
  ADD CONSTRAINT `FeePayments_ibfk_3` FOREIGN KEY (`FeeId`) REFERENCES `Fees` (`FeeId`);
