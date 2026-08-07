-- Migration: add CurrentSectionId to Students (run on existing DBs)
-- Safe to re-run if column already exists (manual check recommended).

ALTER TABLE `Students`
  ADD COLUMN `CurrentSectionId` int DEFAULT NULL AFTER `CurrentClassId`;

ALTER TABLE `Students`
  ADD KEY `idx_students_section` (`CurrentSectionId`);

ALTER TABLE `Students`
  ADD CONSTRAINT `fk_students_section`
    FOREIGN KEY (`CurrentSectionId`) REFERENCES `Sections` (`SectionId`)
    ON DELETE SET NULL;
