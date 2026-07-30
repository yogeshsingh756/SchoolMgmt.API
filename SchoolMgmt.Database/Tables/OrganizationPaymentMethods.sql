-- Table: OrganizationPaymentMethods
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `OrganizationPaymentMethods` (
  `PaymentMethodId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `MethodType` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `UpiId` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `QrImageUrl` longtext COLLATE utf8mb4_general_ci,
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedBy` int NOT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `OrganizationPaymentMethods`
  ADD PRIMARY KEY (`PaymentMethodId`);

ALTER TABLE `OrganizationPaymentMethods`
  MODIFY `PaymentMethodId` int NOT NULL AUTO_INCREMENT;
