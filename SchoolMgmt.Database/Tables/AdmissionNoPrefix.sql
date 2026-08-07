-- Table: AdmissionNoPrefix
-- Maps a unique admission-number prefix to a class (per organization).

CREATE TABLE IF NOT EXISTS `AdmissionNoPrefix` (
  `PrefixId` int NOT NULL AUTO_INCREMENT,
  `OrganizationId` int NOT NULL,
  `ClassId` int NOT NULL,
  `Prefix` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `NextSequence` int NOT NULL DEFAULT 1,
  `PadLength` tinyint NOT NULL DEFAULT 2,
  `IsActive` tinyint(1) DEFAULT 1,
  `IsDeleted` tinyint(1) DEFAULT 0,
  `CreatedBy` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PrefixId`),
  UNIQUE KEY `uq_prefix_org_class` (`OrganizationId`, `ClassId`),
  UNIQUE KEY `uq_prefix_org_value` (`OrganizationId`, `Prefix`),
  KEY `idx_admission_prefix_class` (`ClassId`),
  CONSTRAINT `fk_admission_prefix_org` FOREIGN KEY (`OrganizationId`) REFERENCES `Organizations` (`OrganizationId`) ON DELETE CASCADE,
  CONSTRAINT `fk_admission_prefix_class` FOREIGN KEY (`ClassId`) REFERENCES `Classes` (`ClassId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
