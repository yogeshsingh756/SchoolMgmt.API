-- Procedure: sp_Admin_ClassSubjects_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_ClassSubjects_Create`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_ClassSubjects_Create` (IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_SubjectId` INT, IN `p_CreatedBy` INT)   BEGIN
  DECLARE v_class_exists INT DEFAULT 0;
  DECLARE v_subject_exists INT DEFAULT 0;
  -- verify class belongs to org
  SELECT COUNT(*) INTO v_class_exists FROM Classes WHERE ClassId = p_ClassId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;
  IF v_class_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid ClassId or Class does not belong to organization.';
  END IF;

  -- verify subject belongs to org
  SELECT COUNT(*) INTO v_subject_exists FROM Subjects WHERE SubjectId = p_SubjectId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;
  IF v_subject_exists = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid SubjectId or Subject does not belong to organization.';
  END IF;

  -- prevent duplicate mapping
  IF EXISTS(SELECT 1 FROM ClassSubjects WHERE ClassId = p_ClassId AND SubjectId = p_SubjectId AND OrganizationId = p_OrganizationId And IsActive = 1) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Subject already assigned to class.';
  END IF;

  INSERT INTO ClassSubjects (OrganizationId, ClassId, SubjectId, IsActive, CreatedOn, CreatedBy)
  VALUES (p_OrganizationId, p_ClassId, p_SubjectId, 1, NOW(), p_CreatedBy);

  SELECT LAST_INSERT_ID() AS ClassSubjectId, 'Subject assigned to class.' AS Message;
END$$

DELIMITER ;