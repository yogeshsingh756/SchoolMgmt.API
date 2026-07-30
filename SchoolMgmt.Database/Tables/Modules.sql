-- Table: Modules
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Modules` (
  `ModuleId` int NOT NULL,
  `ModuleName` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Icon` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RoutePath` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OrderNo` int DEFAULT '0',
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Modules`
  ADD PRIMARY KEY (`ModuleId`);

ALTER TABLE `Modules`
  MODIFY `ModuleId` int NOT NULL AUTO_INCREMENT;
