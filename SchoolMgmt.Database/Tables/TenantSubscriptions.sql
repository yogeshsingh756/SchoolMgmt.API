-- Table: TenantSubscriptions
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `TenantSubscriptions` (
  `TenantSubscriptionId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `PlanId` int NOT NULL,
  `StartedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `ExpiresAt` datetime DEFAULT NULL,
  `IsTrial` tinyint(1) DEFAULT '0',
  `Status` enum('Active','Expired','Cancelled') COLLATE utf8mb4_general_ci DEFAULT 'Active',
  `AutoRenew` tinyint(1) DEFAULT '0',
  `PaymentMethod` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LastPaymentRef` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `TenantSubscriptions`
  ADD PRIMARY KEY (`TenantSubscriptionId`),
  ADD KEY `PlanId` (`PlanId`),
  ADD KEY `idx_tenant_sub_org` (`OrganizationId`);

ALTER TABLE `TenantSubscriptions`
  MODIFY `TenantSubscriptionId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `TenantSubscriptions`
  ADD CONSTRAINT `TenantSubscriptions_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `TenantSubscriptions_ibfk_2` FOREIGN KEY (`PlanId`) REFERENCES `SubscriptionPlans` (`PlanId`);
