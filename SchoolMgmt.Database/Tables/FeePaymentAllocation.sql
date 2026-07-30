-- Table: FeePaymentAllocation
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `FeePaymentAllocation` (
  `AllocationId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `PaymentId` int NOT NULL,
  `InvoiceId` int NOT NULL,
  `InvoiceItemId` int NOT NULL,
  `AllocatedAmount` decimal(10,2) NOT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `FeePaymentAllocation`
  ADD PRIMARY KEY (`AllocationId`),
  ADD KEY `ix_alloc` (`OrganizationId`,`PaymentId`,`InvoiceId`,`InvoiceItemId`),
  ADD KEY `idx_payment_alloc_payment` (`OrganizationId`,`PaymentId`);

ALTER TABLE `FeePaymentAllocation`
  MODIFY `AllocationId` int NOT NULL AUTO_INCREMENT;
