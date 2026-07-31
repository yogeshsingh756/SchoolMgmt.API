-- Procedure: sp_Admin_ClassFeeMaster_GetAll
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_ClassFeeMaster_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_ClassFeeMaster_GetAll` (IN `p_OrganizationId` INT, IN `p_PageNumber` INT, IN `p_PageSize` INT, IN `p_Search` VARCHAR(100))   BEGIN
  DECLARE v_PageNumber INT DEFAULT 1;
  DECLARE v_PageSize   INT DEFAULT 10;
  DECLARE v_Offset     INT DEFAULT 0;

  -- Assign default values if null
  SET v_PageNumber = IFNULL(p_PageNumber, 1);
  SET v_PageSize   = IFNULL(p_PageSize, 10);
  SET v_Offset     = (v_PageNumber - 1) * v_PageSize;

  -- Main Data Query
  SELECT SQL_CALC_FOUND_ROWS
         cfm.ClassFeeId, cfm.ClassId, c.ClassName, cfm.Section,
         cfm.TermId, t.TermName, cfm.SessionId, s.SessionName,
         cfm.FeeTypeId, ft.FeeTypeName,
         cfm.Amount, cfm.DueDate, cfm.IsActive, cfm.CreatedOn
  FROM ClassFeeMaster cfm
  INNER JOIN Classes c ON c.ClassId = cfm.ClassId
  INNER JOIN FeeTypes ft ON ft.FeeTypeId = cfm.FeeTypeId
  LEFT JOIN AcademicTerms t ON t.TermId = cfm.TermId
  LEFT JOIN AcademicSessions s ON s.SessionId = cfm.SessionId
  WHERE cfm.OrganizationId = p_OrganizationId
    AND cfm.IsDeleted = 0
    AND (
         p_Search IS NULL OR p_Search = '' 
         OR c.ClassName LIKE CONCAT('%', p_Search, '%')
         OR ft.FeeTypeName LIKE CONCAT('%', p_Search, '%')
    )
  ORDER BY c.ClassName, ft.FeeTypeName
  LIMIT v_Offset, v_PageSize;

  -- Return total rows found
  SELECT FOUND_ROWS() AS TotalRows;
END$$

DELIMITER ;