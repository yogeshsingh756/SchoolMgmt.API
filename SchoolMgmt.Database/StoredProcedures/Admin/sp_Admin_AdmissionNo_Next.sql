-- Procedure: sp_Admin_AdmissionNo_Next
-- Allocates next admission number for a class (Prefix + zero-padded sequence).

DROP PROCEDURE IF EXISTS `sp_Admin_AdmissionNo_Next`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_AdmissionNo_Next` (
  IN `p_OrganizationId` INT,
  IN `p_ClassId` INT
)
proc_label: BEGIN
  DECLARE v_PrefixId INT DEFAULT NULL;
  DECLARE v_Prefix VARCHAR(20);
  DECLARE v_Seq INT;
  DECLARE v_Pad INT;
  DECLARE v_AdmissionNo VARCHAR(50);
  DECLARE v_Dup INT DEFAULT 1;
  DECLARE v_Attempts INT DEFAULT 0;

  SELECT PrefixId, Prefix, NextSequence, PadLength
    INTO v_PrefixId, v_Prefix, v_Seq, v_Pad
  FROM AdmissionNoPrefix
  WHERE OrganizationId = p_OrganizationId
    AND ClassId = p_ClassId
    AND IFNULL(IsDeleted, 0) = 0
    AND IFNULL(IsActive, 1) = 1
  LIMIT 1
  FOR UPDATE;

  IF v_PrefixId IS NULL THEN
    SELECT 0 AS SuccessFlag, NULL AS AdmissionNo, 'Configure admission prefix for this class first.' AS Message;
    LEAVE proc_label;
  END IF;

  SET v_Pad = IFNULL(NULLIF(v_Pad, 0), 2);

  -- Skip any admission numbers that already exist (collision / gaps)
  WHILE v_Dup > 0 AND v_Attempts < 1000 DO
    SET v_AdmissionNo = CONCAT(v_Prefix, LPAD(v_Seq, v_Pad, '0'));
    SELECT COUNT(*) INTO v_Dup
    FROM Students
    WHERE OrganizationId = p_OrganizationId
      AND AdmissionNo = v_AdmissionNo
      AND IFNULL(IsDeleted, 0) = 0;
    IF v_Dup > 0 THEN
      SET v_Seq = v_Seq + 1;
      SET v_Attempts = v_Attempts + 1;
    END IF;
  END WHILE;

  IF v_Dup > 0 THEN
    SELECT 0 AS SuccessFlag, NULL AS AdmissionNo, 'Unable to generate a unique admission number.' AS Message;
    LEAVE proc_label;
  END IF;

  UPDATE AdmissionNoPrefix
  SET NextSequence = v_Seq + 1,
      ModifiedOn = NOW()
  WHERE PrefixId = v_PrefixId;

  SELECT 1 AS SuccessFlag, v_AdmissionNo AS AdmissionNo, 'OK' AS Message;
END$$

DELIMITER ;
