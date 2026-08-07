-- Procedure: sp_Admin_StudentOldFee_Upsert

DROP PROCEDURE IF EXISTS `sp_Admin_StudentOldFee_Upsert`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_StudentOldFee_Upsert` (
  IN `p_OldFeeId` INT,
  IN `p_OrganizationId` INT,
  IN `p_StudentId` INT,
  IN `p_SessionId` INT,
  IN `p_TotalAmount` DECIMAL(10,2),
  IN `p_Notes` VARCHAR(255),
  IN `p_IsActive` TINYINT(1),
  IN `p_ModifiedBy` INT
)
BEGIN
  DECLARE v_Paid DECIMAL(10,2) DEFAULT 0;
  SET p_SessionId = NULLIF(p_SessionId, 0);

  IF IFNULL(p_OldFeeId, 0) = 0 THEN
    IF EXISTS (
      SELECT 1 FROM StudentOldFee
      WHERE OrganizationId = p_OrganizationId AND StudentId = p_StudentId AND IsDeleted = 0
    ) THEN
      SELECT 0 AS OldFeeId, 0 AS SuccessFlag, 'Old fee already mapped for this student.' AS Message;
    ELSE
      INSERT INTO StudentOldFee
        (OrganizationId, StudentId, SessionId, TotalAmount, PaidAmount, Notes, IsActive, CreatedBy, CreatedOn)
      VALUES
        (p_OrganizationId, p_StudentId, p_SessionId, p_TotalAmount, 0, p_Notes, IFNULL(p_IsActive,1), p_ModifiedBy, NOW());
      SELECT LAST_INSERT_ID() AS OldFeeId, 1 AS SuccessFlag, 'Old fee mapped.' AS Message;
    END IF;
  ELSE
    SELECT PaidAmount INTO v_Paid FROM StudentOldFee
    WHERE OldFeeId = p_OldFeeId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;
    IF v_Paid IS NULL THEN
      SELECT 0 AS OldFeeId, 0 AS SuccessFlag, 'Old fee not found.' AS Message;
    ELSEIF p_TotalAmount < v_Paid THEN
      SELECT p_OldFeeId AS OldFeeId, 0 AS SuccessFlag, 'Total cannot be less than already paid amount.' AS Message;
    ELSE
      UPDATE StudentOldFee
      SET SessionId = p_SessionId,
          TotalAmount = p_TotalAmount,
          Notes = p_Notes,
          IsActive = IFNULL(p_IsActive, 1),
          ModifiedBy = p_ModifiedBy,
          ModifiedOn = NOW()
      WHERE OldFeeId = p_OldFeeId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;
      SELECT p_OldFeeId AS OldFeeId, 1 AS SuccessFlag, 'Old fee updated.' AS Message;
    END IF;
  END IF;
END$$

DELIMITER ;
