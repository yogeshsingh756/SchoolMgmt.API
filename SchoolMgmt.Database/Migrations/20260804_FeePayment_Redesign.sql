-- Migration: fee payment redesign (run on existing DBs)

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

-- ClassFeeMaster.SectionId (real Sections FK; Section text kept for display fallback)
SET @col := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ClassFeeMaster' AND COLUMN_NAME = 'SectionId'
);
SET @sql := IF(@col = 0,
  'ALTER TABLE `ClassFeeMaster` ADD COLUMN `SectionId` int DEFAULT NULL AFTER `Section`, ADD KEY `ix_classfee_section` (`SectionId`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- FeePayment.PaymentTarget + SessionId
SET @col := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'FeePayment' AND COLUMN_NAME = 'PaymentTarget'
);
SET @sql := IF(@col = 0,
  'ALTER TABLE `FeePayment` ADD COLUMN `PaymentTarget` varchar(20) NOT NULL DEFAULT ''TermFee'' AFTER `StudentId`, ADD COLUMN `SessionId` int DEFAULT NULL AFTER `PaymentTarget`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- FeePaymentAllocation: allow non-invoice allocations
SET @col := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'FeePaymentAllocation' AND COLUMN_NAME = 'ClassFeeId'
);
SET @sql := IF(@col = 0,
  'ALTER TABLE `FeePaymentAllocation`
     MODIFY `InvoiceId` int NULL,
     MODIFY `InvoiceItemId` int NULL,
     ADD COLUMN `ClassFeeId` int DEFAULT NULL AFTER `InvoiceItemId`,
     ADD COLUMN `FeeTypeId` int DEFAULT NULL AFTER `ClassFeeId`,
     ADD COLUMN `TermId` int DEFAULT NULL AFTER `FeeTypeId`,
     ADD COLUMN `OldFeeId` int DEFAULT NULL AFTER `TermId`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
