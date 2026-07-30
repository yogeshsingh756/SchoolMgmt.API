-- Procedure: sp_Admin_Concessions_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Concessions_Upsert`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Concessions_Upsert` (IN `p_OrganizationId` INT, IN `p_ConcessionId` INT, IN `p_StudentId` INT, IN `p_FeeTypeId` INT, IN `p_DiscountType` ENUM('Flat','Percent'), IN `p_DiscountValue` DECIMAL(10,2), IN `p_Remark` VARCHAR(255), IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
  IF IFNULL(p_ConcessionId,0)=0 THEN
    INSERT INTO StudentFeeConcessions
      (OrganizationId, StudentId, FeeTypeId, DiscountType, DiscountValue, Remark, IsActive, CreatedBy)
    VALUES
      (p_OrganizationId, p_StudentId, p_FeeTypeId, p_DiscountType, p_DiscountValue, p_Remark, IFNULL(p_IsActive,1), p_ModifiedBy);
    SELECT LAST_INSERT_ID() AS ConcessionId;
  ELSE
    UPDATE StudentFeeConcessions
       SET DiscountType = p_DiscountType,
           DiscountValue = p_DiscountValue,
           Remark = p_Remark,
           IsActive = IFNULL(p_IsActive,1),
           ModifiedBy = p_ModifiedBy,
           ModifiedOn = NOW()
     WHERE ConcessionId = p_ConcessionId
       AND OrganizationId = p_OrganizationId
       AND IsDeleted = 0;
    SELECT p_ConcessionId AS ConcessionId;
  END IF;
END$$

DELIMITER ;