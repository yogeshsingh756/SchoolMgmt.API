-- Table: StudentFeeInvoiceItem
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `StudentFeeInvoiceItem` (
  `InvoiceItemId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `InvoiceId` int NOT NULL,
  `FeeTypeId` int NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `DiscountAmount` decimal(10,2) DEFAULT '0.00',
  `NetAmount` decimal(10,2) NOT NULL,
  `PaidAmount` decimal(10,2) DEFAULT '0.00',
  `IsDeleted` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `StudentFeeInvoiceItem`
  ADD PRIMARY KEY (`InvoiceItemId`),
  ADD KEY `ix_items_invoice` (`OrganizationId`,`InvoiceId`,`IsDeleted`),
  ADD KEY `idx_invoiceitem_invoice` (`InvoiceId`),
  ADD KEY `idx_invoiceitem_feetype` (`OrganizationId`,`FeeTypeId`);

ALTER TABLE `StudentFeeInvoiceItem`
  MODIFY `InvoiceItemId` int NOT NULL AUTO_INCREMENT;
