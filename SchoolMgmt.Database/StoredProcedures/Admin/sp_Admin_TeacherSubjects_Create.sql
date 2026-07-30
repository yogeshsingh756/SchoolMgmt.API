-- Procedure: sp_Admin_TeacherSubjects_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_TeacherSubjects_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_TeacherSubjects_Create` (IN `p_OrganizationId` INT, IN `p_TeacherId` INT, IN `p_ClassId` INT, IN `p_SectionId` INT, IN `p_SubjectId` INT, IN `p_IsPrimary` TINYINT(1), IN `p_CreatedBy` INT)   BEGIN
  DECLARE v_teacher_exists INT DEFAULT 0;
  DECLARE v_class_exists INT DEFAULT 0;
  DECLARE v_subject_exists INT DEFAULT 0;
  DECLARE v_section_exists INT DEFAULT 1;

  -- validate teacher belongs to org
  SELECT COUNT(*) INTO v_teacher_exists FROM Teachers WHERE TeacherId = p_TeacherId AND OrganizationId = p_OrganizationId;
  IF v_teacher_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid TeacherId or Teacher does not belong to organization.';
  END IF;

  -- validate class belongs to org
  SELECT COUNT(*) INTO v_class_exists FROM Classes WHERE ClassId = p_ClassId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;
  IF v_class_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid ClassId or Class does not belong to organization.';
  END IF;

  -- validate subject belongs to org
  SELECT COUNT(*) INTO v_subject_exists FROM Subjects WHERE SubjectId = p_SubjectId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;
  IF v_subject_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid SubjectId or Subject does not belong to organization.';
  END IF;

  -- if section passed, validate it belongs to this class & org
  IF p_SectionId IS NOT NULL THEN
    SELECT COUNT(*) INTO v_section_exists FROM Sections WHERE SectionId = p_SectionId AND ClassId = p_ClassId AND OrganizationId = p_OrganizationId;
    IF v_section_exists = 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid SectionId or does not belong to class/organization.';
    END IF;
  END IF;

  -- ✅ Prevent Duplicate Mapping
  IF EXISTS (
    SELECT 1 FROM TeacherSubjects
    WHERE TeacherId = p_TeacherId
      AND ClassId = p_ClassId
      AND SubjectId = p_SubjectId
      AND (SectionId <=> p_SectionId)  -- NULL-safe comparison
      AND OrganizationId = p_OrganizationId
      AND IsActive = 1
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Teacher already assigned for this class/subject/section.';
  END IF;

  -- ✅ Insert new record
  INSERT INTO TeacherSubjects
    (OrganizationId, TeacherId, ClassId, SectionId, SubjectId, IsPrimary, IsActive, CreatedOn, CreatedBy)
  VALUES
    (p_OrganizationId, p_TeacherId, p_ClassId, p_SectionId, p_SubjectId,
     IFNULL(p_IsPrimary, 0), 1, NOW(), p_CreatedBy);

  -- ✅ Return
  SELECT LAST_INSERT_ID() AS TeacherSubjectId,
         'Teacher assigned to subject successfully.' AS Message;
END$$

DELIMITER ;