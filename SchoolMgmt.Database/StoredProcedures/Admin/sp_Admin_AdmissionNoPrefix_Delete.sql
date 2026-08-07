-- Procedure: sp_Admin_AdmissionNoPrefix_Delete

DROP PROCEDURE IF EXISTS `sp_Admin_AdmissionNoPrefix_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_AdmissionNoPrefix_Delete` (
  IN `p_PrefixId` INT,
  IN `p_OrganizationId` INT,
  IN `p_ModifiedBy` INT
)
BEGIN
  UPDATE AdmissionNoPrefix
  SET IsDeleted = 1,
      IsActive = 0,
      ModifiedBy = p_ModifiedBy,
      ModifiedOn = NOW()
  WHERE PrefixId = p_PrefixId
    AND OrganizationId = p_OrganizationId
    AND IFNULL(IsDeleted, 0) = 0;

  IF ROW_COUNT() > 0 THEN
    SELECT 1 AS SuccessFlag, 'Deleted' AS Message;
  ELSE
    SELECT 0 AS SuccessFlag, 'Prefix not found.' AS Message;
  END IF;
END$$

DELIMITER ;
