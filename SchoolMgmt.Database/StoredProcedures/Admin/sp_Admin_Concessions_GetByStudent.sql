-- Procedure: sp_Admin_Concessions_GetByStudent
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Concessions_GetByStudent`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Concessions_GetByStudent` (IN `p_OrganizationId` INT, IN `p_StudentId` INT)   BEGIN
  SELECT c.ConcessionId, c.FeeTypeId, ft.FeeTypeName, c.DiscountType, c.DiscountValue, c.Remark, c.IsActive
  FROM StudentFeeConcessions c
  INNER JOIN FeeTypes ft ON ft.FeeTypeId = c.FeeTypeId
  WHERE c.OrganizationId = p_OrganizationId AND c.StudentId = p_StudentId AND c.IsDeleted = 0;
END$$

DELIMITER ;