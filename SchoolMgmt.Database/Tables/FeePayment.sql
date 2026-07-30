-- Table: FeePayment
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `FeePayment` (
  `PaymentId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `ReceiptNo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `PaymentDate` datetime NOT NULL,
  `PaymentMode` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `ReferenceNo` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Notes` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TotalPaidAmount` decimal(10,2) NOT NULL,
  `CreatedBy` int NOT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `FeePayment`
  ADD PRIMARY KEY (`PaymentId`),
  ADD UNIQUE KEY `uq_receipt` (`OrganizationId`,`ReceiptNo`),
  ADD KEY `ix_payment_student` (`OrganizationId`,`StudentId`),
  ADD KEY `idx_fee_payment_org_date` (`OrganizationId`,`PaymentDate`);

ALTER TABLE `FeePayment`
  MODIFY `PaymentId` int NOT NULL AUTO_INCREMENT;
