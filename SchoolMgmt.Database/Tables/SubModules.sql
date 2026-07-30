-- Table: SubModules
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `SubModules` (
  `SubModuleId` int NOT NULL,
  `ModuleId` int NOT NULL,
  `SubModuleName` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RoutePath` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `OrderNo` int DEFAULT '0',
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `CreatedBy` int DEFAULT NULL,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `SubModules`
  ADD PRIMARY KEY (`SubModuleId`),
  ADD KEY `ModuleId` (`ModuleId`);

ALTER TABLE `SubModules`
  MODIFY `SubModuleId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `SubModules`
  ADD CONSTRAINT `SubModules_ibfk_1` FOREIGN KEY (`ModuleId`) REFERENCES `Modules` (`ModuleId`) ON DELETE CASCADE;
