-- Procedure: sp_Admin_AdmissionNoPrefix_Upsert

DROP PROCEDURE IF EXISTS `sp_Admin_AdmissionNoPrefix_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_AdmissionNoPrefix_Upsert` (
  IN `p_PrefixId` INT,
  IN `p_OrganizationId` INT,
  IN `p_ClassId` INT,
  IN `p_Prefix` VARCHAR(20),
  IN `p_PadLength` TINYINT,
  IN `p_IsActive` TINYINT,
  IN `p_ModifiedBy` INT
)
BEGIN
  DECLARE v_Exists INT DEFAULT 0;
  DECLARE v_ClassOk INT DEFAULT 0;
  DECLARE v_DupPrefix INT DEFAULT 0;
  DECLARE v_DupClass INT DEFAULT 0;

  SET p_Prefix = TRIM(IFNULL(p_Prefix, ''));
  SET p_PadLength = IFNULL(NULLIF(p_PadLength, 0), 2);
  SET p_IsActive = IFNULL(p_IsActive, 1);

  IF p_Prefix = '' OR p_ClassId IS NULL OR p_ClassId = 0 THEN
    SELECT 0 AS SuccessFlag, 0 AS NewId, 'Class and prefix are required.' AS Message;
  ELSE
    SELECT COUNT(*) INTO v_ClassOk
    FROM Classes
    WHERE ClassId = p_ClassId
      AND OrganizationId = p_OrganizationId
      AND IFNULL(IsDeleted, 0) = 0;

    IF v_ClassOk = 0 THEN
      SELECT 0 AS SuccessFlag, 0 AS NewId, 'Invalid class for this organization.' AS Message;
    ELSE
      -- Same prefix cannot be used by another row in the org
      SELECT COUNT(*) INTO v_DupPrefix
      FROM AdmissionNoPrefix
      WHERE OrganizationId = p_OrganizationId
        AND Prefix = p_Prefix
        AND IFNULL(IsDeleted, 0) = 0
        AND (IFNULL(p_PrefixId, 0) = 0 OR PrefixId <> p_PrefixId);

      IF v_DupPrefix > 0 THEN
        SELECT 0 AS SuccessFlag, 0 AS NewId, 'This prefix is already used by another class.' AS Message;
      ELSE
        -- One prefix per class
        SELECT COUNT(*) INTO v_DupClass
        FROM AdmissionNoPrefix
        WHERE OrganizationId = p_OrganizationId
          AND ClassId = p_ClassId
          AND IFNULL(IsDeleted, 0) = 0
          AND (IFNULL(p_PrefixId, 0) = 0 OR PrefixId <> p_PrefixId);

        IF v_DupClass > 0 AND IFNULL(p_PrefixId, 0) = 0 THEN
          SELECT 0 AS SuccessFlag, 0 AS NewId, 'This class already has an admission prefix.' AS Message;
        ELSEIF IFNULL(p_PrefixId, 0) = 0 THEN
          INSERT INTO AdmissionNoPrefix (
            OrganizationId, ClassId, Prefix, NextSequence, PadLength, IsActive, IsDeleted, CreatedBy, CreatedOn
          )
          VALUES (
            p_OrganizationId, p_ClassId, p_Prefix, 1, p_PadLength, p_IsActive, 0, p_ModifiedBy, NOW()
          );
          SELECT 1 AS SuccessFlag, LAST_INSERT_ID() AS NewId, 'Created' AS Message;
        ELSE
          SELECT COUNT(*) INTO v_Exists
          FROM AdmissionNoPrefix
          WHERE PrefixId = p_PrefixId AND OrganizationId = p_OrganizationId AND IFNULL(IsDeleted, 0) = 0;

          IF v_Exists = 0 THEN
            SELECT 0 AS SuccessFlag, 0 AS NewId, 'Prefix record not found.' AS Message;
          ELSE
            UPDATE AdmissionNoPrefix
            SET ClassId = p_ClassId,
                Prefix = p_Prefix,
                PadLength = p_PadLength,
                IsActive = p_IsActive,
                ModifiedBy = p_ModifiedBy,
                ModifiedOn = NOW()
            WHERE PrefixId = p_PrefixId AND OrganizationId = p_OrganizationId;
            SELECT 1 AS SuccessFlag, p_PrefixId AS NewId, 'Updated' AS Message;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END$$

DELIMITER ;
