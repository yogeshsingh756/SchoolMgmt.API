-- Table: Payments
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Payments` (
  `PaymentId` int NOT NULL,
  `TenantSubscriptionId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `Currency` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'USD',
  `PaymentDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `PaymentMode` enum('Card','Online','Manual','BankTransfer','OneTime') COLLATE utf8mb4_general_ci DEFAULT 'Online',
  `TransactionRef` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Status` enum('Pending','Completed','Failed','Refunded') COLLATE utf8mb4_general_ci DEFAULT 'Completed',
  `Notes` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Payments`
  ADD PRIMARY KEY (`PaymentId`),
  ADD KEY `TenantSubscriptionId` (`TenantSubscriptionId`),
  ADD KEY `OrganizationId` (`OrganizationId`);

ALTER TABLE `Payments`
  MODIFY `PaymentId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Payments`
  ADD CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`TenantSubscriptionId`) REFERENCES `TenantSubscriptions` (`TenantSubscriptionId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Payments_ibfk_2` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE;
