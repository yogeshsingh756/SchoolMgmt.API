-- Table: Users
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Users` (
  `UserId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `RoleId` int DEFAULT NULL,
  `FirstName` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `LastName` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `PasswordHash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `Phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Gender` enum('Male','Female','Other') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `FailedLoginAttempts` int DEFAULT '0',
  `LockoutUntil` datetime DEFAULT NULL,
  `CreatedBy` int DEFAULT NULL,
  `Address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Category` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Users`
  ADD PRIMARY KEY (`UserId`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `RoleId` (`RoleId`),
  ADD KEY `idx_users_org` (`OrganizationId`);

ALTER TABLE `Users`
  MODIFY `UserId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Users`
  ADD CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Users_ibfk_2` FOREIGN KEY (`RoleId`) REFERENCES `Roles` (`RoleId`);
