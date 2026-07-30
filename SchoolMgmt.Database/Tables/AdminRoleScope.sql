-- Table: AdminRoleScope
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `AdminRoleScope` (
  `AdminRoleScopeId` int NOT NULL,
  `AdminUserId` int NOT NULL,
  `AllowedRoleId` int NOT NULL,
  `CreatedBy` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `AdminRoleScope`
  ADD PRIMARY KEY (`AdminRoleScopeId`),
  ADD KEY `AdminUserId` (`AdminUserId`),
  ADD KEY `AllowedRoleId` (`AllowedRoleId`);

ALTER TABLE `AdminRoleScope`
  MODIFY `AdminRoleScopeId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `AdminRoleScope`
  ADD CONSTRAINT `AdminRoleScope_ibfk_1` FOREIGN KEY (`AdminUserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE,
  ADD CONSTRAINT `AdminRoleScope_ibfk_2` FOREIGN KEY (`AllowedRoleId`) REFERENCES `Roles` (`RoleId`) ON DELETE CASCADE;
