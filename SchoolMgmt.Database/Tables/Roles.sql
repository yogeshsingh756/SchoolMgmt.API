-- Table: Roles
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Roles` (
  `RoleId` int NOT NULL,
  `RoleName` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `CreatedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Roles`
  ADD PRIMARY KEY (`RoleId`),
  ADD UNIQUE KEY `RoleName` (`RoleName`);

ALTER TABLE `Roles`
  MODIFY `RoleId` int NOT NULL AUTO_INCREMENT;
