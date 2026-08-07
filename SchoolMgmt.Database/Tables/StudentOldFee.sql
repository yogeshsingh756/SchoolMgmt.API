-- Table: StudentOldFee

CREATE TABLE IF NOT EXISTS `StudentOldFee` (
  `OldFeeId` int NOT NULL AUTO_INCREMENT,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `SessionId` int DEFAULT NULL,
  `TotalAmount` decimal(10,2) NOT NULL,
  `PaidAmount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `Notes` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedBy` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`OldFeeId`),
  UNIQUE KEY `uq_student_oldfee_active` (`OrganizationId`,`StudentId`,`IsDeleted`),
  KEY `ix_oldfee_student` (`OrganizationId`,`StudentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
