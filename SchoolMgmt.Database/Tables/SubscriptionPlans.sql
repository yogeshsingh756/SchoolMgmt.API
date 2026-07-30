-- Table: SubscriptionPlans
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `SubscriptionPlans` (
  `PlanId` int NOT NULL,
  `PlanName` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `Description` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `BillingCycle` enum('OneTime','Monthly','Quarterly','SemiAnnual','Yearly','Custom') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Monthly',
  `CustomMonths` int DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `CreatedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `SubscriptionPlans`
  ADD PRIMARY KEY (`PlanId`),
  ADD KEY `idx_subscription_plans_active` (`IsActive`);

ALTER TABLE `SubscriptionPlans`
  MODIFY `PlanId` int NOT NULL AUTO_INCREMENT;
