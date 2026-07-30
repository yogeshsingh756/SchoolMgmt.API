-- Table: ReceiptSequence
-- Extracted from phpMyAdmin structure dump

CREATE TABLE `ReceiptSequence` (
  `OrganizationId` int NOT NULL,
  `LastNumber` int NOT NULL DEFAULT '0',
  `ModifiedOn` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes / AUTO_INCREMENT / Constraints
ALTER TABLE `ReceiptSequence`
  ADD PRIMARY KEY (`OrganizationId`);
