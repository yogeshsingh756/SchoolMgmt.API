-- Procedure: sp_Admin_ClassFeeMaster_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_ClassFeeMaster_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_ClassFeeMaster_Upsert` (IN `p_ClassFeeId` INT, IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_Section` VARCHAR(10), IN `p_TermId` INT, IN `p_SessionId` INT, IN `p_FeeTypeId` INT, IN `p_Amount` DECIMAL(10,2), IN `p_DueDate` DATE, IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
  IF IFNULL(p_ClassFeeId, 0) = 0 THEN
    -- Insert new record
    INSERT INTO ClassFeeMaster
      (OrganizationId, ClassId, Section, TermId, SessionId, FeeTypeId, Amount, DueDate, IsActive, CreatedBy, CreatedOn)
    VALUES
      (p_OrganizationId, p_ClassId, p_Section, p_TermId, p_SessionId, p_FeeTypeId, p_Amount, p_DueDate, IFNULL(p_IsActive,1), p_ModifiedBy, NOW());
    
    SELECT LAST_INSERT_ID() AS ClassFeeId;
  
  ELSE
    -- Update existing record
    UPDATE ClassFeeMaster
      SET ClassId = p_ClassId,
          Section = p_Section,
          TermId = p_TermId,
          SessionId = p_SessionId,
          FeeTypeId = p_FeeTypeId,
          Amount = p_Amount,
          DueDate = p_DueDate,
          IsActive = IFNULL(p_IsActive, 1),
          ModifiedBy = p_ModifiedBy,
          ModifiedOn = NOW()
    WHERE ClassFeeId = p_ClassFeeId
      AND OrganizationId = p_OrganizationId
      AND IsDeleted = 0;
    
    SELECT p_ClassFeeId AS ClassFeeId;
  END IF;
END$$

DELIMITER ;