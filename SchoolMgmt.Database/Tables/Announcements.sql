-- Table: Announcements
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `Announcements` (
  `AnnouncementId` int NOT NULL,
  `OrganizationId` int NOT NULL,
  `Title` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `Content` text COLLATE utf8mb4_general_ci,
  `CreatedBy` int DEFAULT NULL,
  `TargetAudience` enum('All','Teachers','Students','Parents') COLLATE utf8mb4_general_ci DEFAULT 'All',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `Announcements`
  ADD PRIMARY KEY (`AnnouncementId`),
  ADD KEY `CreatedBy` (`CreatedBy`),
  ADD KEY `idx_announcements_org` (`OrganizationId`);

ALTER TABLE `Announcements`
  MODIFY `AnnouncementId` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Announcements`
  ADD CONSTRAINT `Announcements_ibfk_1` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  ADD CONSTRAINT `Announcements_ibfk_2` FOREIGN KEY (`CreatedBy`) REFERENCES `Users` (`UserId`);
