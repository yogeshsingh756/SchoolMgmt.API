-- Procedure: sp_Admin_ClassFeeMaster_Upsert

DROP PROCEDURE IF EXISTS `sp_Admin_ClassFeeMaster_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_ClassFeeMaster_Upsert` (
  IN `p_ClassFeeId` INT,
  IN `p_OrganizationId` INT,
  IN `p_ClassId` INT,
  IN `p_Section` VARCHAR(10),
  IN `p_SectionId` INT,
  IN `p_TermId` INT,
  IN `p_SessionId` INT,
  IN `p_FeeTypeId` INT,
  IN `p_Amount` DECIMAL(10,2),
  IN `p_DueDate` DATE,
  IN `p_IsActive` TINYINT(1),
  IN `p_ModifiedBy` INT
)
BEGIN
  DECLARE v_Dup INT DEFAULT 0;
  DECLARE v_SectionName VARCHAR(50);

  SET p_SectionId = NULLIF(p_SectionId, 0);
  SET p_TermId = NULLIF(p_TermId, 0);
  SET p_SessionId = NULLIF(p_SessionId, 0);

  IF p_SectionId IS NOT NULL THEN
    SELECT SectionName INTO v_SectionName
    FROM Sections
    WHERE SectionId = p_SectionId AND OrganizationId = p_OrganizationId AND ClassId = p_ClassId
    LIMIT 1;
    SET p_Section = IFNULL(v_SectionName, p_Section);
  END IF;

  SELECT COUNT(*) INTO v_Dup
  FROM ClassFeeMaster
  WHERE OrganizationId = p_OrganizationId
    AND ClassId = p_ClassId
    AND IFNULL(SectionId, 0) = IFNULL(p_SectionId, 0)
    AND IFNULL(SessionId, 0) = IFNULL(p_SessionId, 0)
    AND IFNULL(TermId, 0) = IFNULL(p_TermId, 0)
    AND FeeTypeId = p_FeeTypeId
    AND IsDeleted = 0
    AND ClassFeeId <> IFNULL(p_ClassFeeId, 0);

  IF v_Dup > 0 THEN
    SELECT 0 AS ClassFeeId, 0 AS SuccessFlag, 'Fee type already mapped for this class/section/session/term.' AS Message;
  ELSEIF IFNULL(p_ClassFeeId, 0) = 0 THEN
    INSERT INTO ClassFeeMaster
      (OrganizationId, ClassId, Section, SectionId, TermId, SessionId, FeeTypeId, Amount, DueDate, IsActive, CreatedBy, CreatedOn)
    VALUES
      (p_OrganizationId, p_ClassId, p_Section, p_SectionId, p_TermId, p_SessionId, p_FeeTypeId, p_Amount, p_DueDate, IFNULL(p_IsActive,1), p_ModifiedBy, NOW());
    SELECT LAST_INSERT_ID() AS ClassFeeId, 1 AS SuccessFlag, 'Created' AS Message;
  ELSE
    UPDATE ClassFeeMaster
      SET ClassId = p_ClassId,
          Section = p_Section,
          SectionId = p_SectionId,
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
    SELECT p_ClassFeeId AS ClassFeeId, 1 AS SuccessFlag, 'Updated' AS Message;
  END IF;
END$$

DELIMITER ;
