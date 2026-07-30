-- Procedure: sp_Fees_Upsert
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Fees_Upsert`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Fees_Upsert` (IN `p_FeeId` INT, IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_FeeType` VARCHAR(50), IN `p_Amount` DECIMAL(10,2), IN `p_DueDate` DATE, IN `p_Term` VARCHAR(20), IN `p_Session` VARCHAR(20), IN `p_Status` ENUM('Pending','Paid','Overdue'), IN `p_ModifiedBy` INT)   BEGIN
    IF p_FeeId = 0 THEN
        INSERT INTO Fees (
            OrganizationId, ClassId, FeeType, Amount, DueDate,
            Term, Session, Status, IsDeleted, CreatedOn, ModifiedOn, ModifiedBy
        ) VALUES (
            p_OrganizationId, p_ClassId, p_FeeType, p_Amount, p_DueDate,
            p_Term, p_Session, p_Status, 0, NOW(), NOW(), p_ModifiedBy
        );
    ELSE
        UPDATE Fees
        SET
            ClassId = p_ClassId,
            FeeType = p_FeeType,
            Amount = p_Amount,
            DueDate = p_DueDate,
            Term = p_Term,
            Session = p_Session,
            Status = p_Status,
            ModifiedOn = NOW(),
            ModifiedBy = p_ModifiedBy
        WHERE FeeId = p_FeeId
          AND OrganizationId = p_OrganizationId;
    END IF;
END$$

DELIMITER ;