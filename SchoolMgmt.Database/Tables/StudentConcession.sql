-- Table: StudentConcession (flat amount per student, Map Old Fee style)

CREATE TABLE IF NOT EXISTS `StudentConcession` (
  `ConcessionId` int NOT NULL AUTO_INCREMENT,
  `OrganizationId` int NOT NULL,
  `StudentId` int NOT NULL,
  `SessionId` int DEFAULT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `Notes` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT '1',
  `IsDeleted` tinyint(1) DEFAULT '0',
  `CreatedBy` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `ModifiedBy` int DEFAULT NULL,
  `ModifiedOn` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ConcessionId`),
  UNIQUE KEY `uq_student_concession_active` (`OrganizationId`,`StudentId`,`IsDeleted`),
  KEY `ix_concession_student` (`OrganizationId`,`StudentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
