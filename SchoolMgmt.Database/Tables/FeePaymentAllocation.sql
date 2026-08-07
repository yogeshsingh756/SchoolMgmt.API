-- Table: FeePaymentAllocation (updated for TermFee / OldFee without invoices)

CREATE TABLE `FeePaymentAllocation` (
  `AllocationId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `PaymentId` int NOT NULL,
  `InvoiceId` int DEFAULT NULL,
  `InvoiceItemId` int DEFAULT NULL,
  `ClassFeeId` int DEFAULT NULL,
  `FeeTypeId` int DEFAULT NULL,
  `TermId` int DEFAULT NULL,
  `OldFeeId` int DEFAULT NULL,
  `AllocatedAmount` decimal(10,2) NOT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `FeePaymentAllocation`
  ADD PRIMARY KEY (`AllocationId`),
  ADD KEY `ix_alloc` (`OrganizationId`,`PaymentId`),
  ADD KEY `idx_payment_alloc_payment` (`OrganizationId`,`PaymentId`);

ALTER TABLE `FeePaymentAllocation`
  MODIFY `AllocationId` int NOT NULL AUTO_INCREMENT;
