-- Procedure: sp_Admin_Subjects_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Subjects_GetAll`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Subjects_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT)   BEGIN
  DECLARE v_Offset INT DEFAULT 0;

  -- calculate offset for pagination
  SET v_Offset = (p_PageNumber - 1) * p_PageSize;

  -- fetch paginated result
  SELECT 
      s.SubjectId,
      s.SubjectName,
      s.SubjectCode,
      s.Description,
      s.IsActive,
      s.CreatedOn,
      s.ModifiedOn
  FROM Subjects s
  WHERE s.OrganizationId = p_OrganizationId AND s.IsDeleted = 0
  ORDER BY s.SubjectName
  LIMIT v_Offset, p_PageSize;

  -- return total count for UI pagination
  SELECT COUNT(*) AS TotalRecords
  FROM Subjects
  WHERE OrganizationId = p_OrganizationId AND IsDeleted = 0;
END$$

DELIMITER ;