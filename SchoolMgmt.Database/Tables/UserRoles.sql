-- Table: UserRoles
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `UserRoles` (
  `UserRoleId` int NOT NULL,
  `UserId` int NOT NULL,
  `RoleId` int NOT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `UserRoles`
  ADD PRIMARY KEY (`UserRoleId`),
  ADD KEY `idx_userroles_user` (`UserId`),
  ADD KEY `idx_userroles_role` (`RoleId`);

ALTER TABLE `UserRoles`
  MODIFY `UserRoleId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `UserRoles`
  ADD CONSTRAINT `UserRoles_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE,
  ADD CONSTRAINT `UserRoles_ibfk_2` FOREIGN KEY (`RoleId`) REFERENCES `Roles` (`RoleId`) ON DELETE CASCADE;
