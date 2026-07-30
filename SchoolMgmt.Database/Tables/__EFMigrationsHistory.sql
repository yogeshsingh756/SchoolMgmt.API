-- Table: __EFMigrationsHistory
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `__EFMigrationsHistory` (
  `MigrationId` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `ProductVersion` varchar(32) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `__EFMigrationsHistory`
  ADD PRIMARY KEY (`MigrationId`);
