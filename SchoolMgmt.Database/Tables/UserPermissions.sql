-- Table: UserPermissions
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `UserPermissions` (
  `UserPermissionId` int NOT NULL,
  `UserId` int NOT NULL,
  `PermissionId` int NOT NULL,
  `CanView` tinyint(1) DEFAULT '0',
  `CanCreate` tinyint(1) DEFAULT '0',
  `CanEdit` tinyint(1) DEFAULT '0',
  `CanDelete` tinyint(1) DEFAULT '0',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `UserPermissions`
  ADD PRIMARY KEY (`UserPermissionId`),
  ADD KEY `PermissionId` (`PermissionId`),
  ADD KEY `idx_userpermissions_user` (`UserId`);

ALTER TABLE `UserPermissions`
  MODIFY `UserPermissionId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `UserPermissions`
  ADD CONSTRAINT `UserPermissions_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE,
  ADD CONSTRAINT `UserPermissions_ibfk_2` FOREIGN KEY (`PermissionId`) REFERENCES `Permissions` (`PermissionId`) ON DELETE CASCADE;
