-- Table: StudentFeeInvoice
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `StudentFeeInvoice` (
  `InvoiceId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `InvoiceNo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `TermId` int DEFAULT NULL,
  `SessionId` int DEFAULT NULL,
  `InvoiceDate` date NOT NULL,
  `DueDate` date DEFAULT NULL,
  `TotalAmount` decimal(10,2) DEFAULT '0.00',
  `TotalDiscount` decimal(10,2) DEFAULT '0.00',
  `NetPayable` decimal(10,2) DEFAULT '0.00',
  `PaidAmount` decimal(10,2) DEFAULT '0.00',
  `BalanceAmount` decimal(10,2) DEFAULT '0.00',
  `Status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'Pending',
  `Notes` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedBy` int NOT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `StudentFeeInvoice`
  ADD PRIMARY KEY (`InvoiceId`),
  ADD UNIQUE KEY `uq_invoice_no` (`OrganizationId`,`InvoiceNo`),
  ADD KEY `ix_invoice_student` (`OrganizationId`,`StudentId`,`IsDeleted`),
  ADD KEY `idx_invoice_org_student` (`OrganizationId`,`StudentId`);

ALTER TABLE `StudentFeeInvoice`
  MODIFY `InvoiceId` int NOT NULL AUTO_INCREMENT;
