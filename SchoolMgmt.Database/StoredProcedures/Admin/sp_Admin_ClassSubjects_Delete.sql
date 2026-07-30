-- Procedure: sp_Admin_ClassSubjects_Delete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_ClassSubjects_Delete`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_ClassSubjects_Delete` (IN `p_OrganizationId` INT, IN `p_ClassSubjectId` INT, IN `p_ModifiedBy` INT)   BEGIN
  UPDATE ClassSubjects
  SET IsActive = 0, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
  WHERE ClassSubjectId = p_ClassSubjectId AND OrganizationId = p_OrganizationId;

  SELECT 1 AS SuccessFlag, 'ClassSubject removed.' AS Message;
END$$

DELIMITER ;