-- Migration: add StudentType (Regular | Private) to Students

ALTER TABLE `Students`
  ADD COLUMN `StudentType` enum('Regular','Private')
    COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Regular'
    AFTER `CurrentSectionId`;
