-- Table: Organizations
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Organizations` (
  `OrganizationId` int NOT NULL,
  `SchoolName` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `Address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `SubscriptionPlanId` int DEFAULT NULL,
  `IsTrial` tinyint(1) DEFAULT '0',
  `TrialExpiresAt` datetime DEFAULT NULL,
  `TenantStatus` enum('Pending','Active','Blocked') COLLATE utf8mb4_general_ci DEFAULT 'Pending',
  `Timezone` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'UTC',
  `Currency` varchar(10) COLLATE utf8mb4_general_ci DEFAULT 'USD',
  `Domain` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CreatedBy` int DEFAULT NULL,
  `LogoUrl` longtext COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Organizations`
  ADD PRIMARY KEY (`OrganizationId`),
  ADD KEY `idx_org_active` (`IsActive`);

ALTER TABLE `Organizations`
  MODIFY `OrganizationId` int NOT NULL AUTO_INCREMENT;
