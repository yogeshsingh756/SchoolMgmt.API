-- Procedure: sp_Admin_StudentOldFee_Delete

DROP PROCEDURE IF EXISTS `sp_Admin_StudentOldFee_Delete`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_StudentOldFee_Delete` (
  IN `p_OrganizationId` INT,
  IN `p_OldFeeId` INT,
  IN `p_ModifiedBy` INT
)
BEGIN
  DECLARE v_Paid DECIMAL(10,2) DEFAULT 0;
  SELECT PaidAmount INTO v_Paid FROM StudentOldFee
  WHERE OldFeeId = p_OldFeeId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;

  IF v_Paid IS NULL THEN
    SELECT 0 AS SuccessFlag, 'Old fee not found.' AS Message;
  ELSEIF v_Paid > 0 THEN
    SELECT 0 AS SuccessFlag, 'Cannot delete old fee with payments.' AS Message;
  ELSE
    UPDATE StudentOldFee
    SET IsDeleted = 1, IsActive = 0, ModifiedBy = p_ModifiedBy, ModifiedOn = NOW()
    WHERE OldFeeId = p_OldFeeId AND OrganizationId = p_OrganizationId;
    SELECT 1 AS SuccessFlag, 'Old fee removed.' AS Message;
  END IF;
END$$

DELIMITER ;
