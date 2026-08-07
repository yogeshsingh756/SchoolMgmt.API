-- Procedure: sp_Admin_AdmissionNoPrefix_GetAll

DROP PROCEDURE IF EXISTS `sp_Admin_AdmissionNoPrefix_GetAll`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_AdmissionNoPrefix_GetAll` (IN `p_OrganizationId` INT)
BEGIN
  SELECT
    p.PrefixId,
    p.OrganizationId,
    p.ClassId,
    c.ClassName,
    p.Prefix,
    p.NextSequence,
    p.PadLength,
    p.IsActive,
    p.CreatedOn,
    p.ModifiedOn
  FROM AdmissionNoPrefix p
  INNER JOIN Classes c ON c.ClassId = p.ClassId AND c.OrganizationId = p.OrganizationId
  WHERE p.OrganizationId = p_OrganizationId
    AND IFNULL(p.IsDeleted, 0) = 0
  ORDER BY c.ClassName, p.Prefix;
END$$

DELIMITER ;
