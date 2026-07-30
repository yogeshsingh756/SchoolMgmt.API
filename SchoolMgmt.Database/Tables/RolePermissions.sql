-- Table: RolePermissions
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `RolePermissions` (
  `RolePermissionId` int NOT NULL,
  `RoleId` int NOT NULL,
  `PermissionId` int NOT NULL,
  `CanView` tinyint(1) DEFAULT '0',
  `CanCreate` tinyint(1) DEFAULT '0',
  `CanEdit` tinyint(1) DEFAULT '0',
  `CanDelete` tinyint(1) DEFAULT '0',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedBy` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `RolePermissions`
  ADD PRIMARY KEY (`RolePermissionId`),
  ADD UNIQUE KEY `uq_role_permission` (`RoleId`,`PermissionId`),
  ADD KEY `idx_rolepermissions_role` (`RoleId`),
  ADD KEY `idx_rolepermissions_permission` (`PermissionId`);

ALTER TABLE `RolePermissions`
  MODIFY `RolePermissionId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `RolePermissions`
  ADD CONSTRAINT `RolePermissions_ibfk_1` FOREIGN KEY (`RoleId`) REFERENCES `Roles` (`RoleId`) ON DELETE CASCADE,
  ADD CONSTRAINT `RolePermissions_ibfk_2` FOREIGN KEY (`PermissionId`) REFERENCES `Permissions` (`PermissionId`) ON DELETE CASCADE;
