-- Table: Permissions
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Permissions` (
  `PermissionId` int NOT NULL,
  `PermissionKey` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `PermissionName` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `ModuleName` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `Description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `SubModuleId` int DEFAULT NULL,
  `ModuleId` int DEFAULT NULL,
  `IsDeleted` tinyint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Permissions`
  ADD PRIMARY KEY (`PermissionId`),
  ADD UNIQUE KEY `PermissionKey` (`PermissionKey`),
  ADD KEY `idx_permissions_module` (`ModuleName`),
  ADD KEY `FK_Permissions_SubModules` (`SubModuleId`),
  ADD KEY `FK_Permissions_Modules` (`ModuleId`);

ALTER TABLE `Permissions`
  MODIFY `PermissionId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Permissions`
  ADD CONSTRAINT `FK_Permissions_Modules` FOREIGN KEY (`ModuleId`) REFERENCES `Modules` (`ModuleId`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Permissions_SubModules` FOREIGN KEY (`SubModuleId`) REFERENCES `SubModules` (`SubModuleId`) ON DELETE SET NULL;
