-- Procedure: sp_Report_StudentPaymentDetails

DROP PROCEDURE IF EXISTS `sp_Report_StudentPaymentDetails`;

DELIMITER $$

CREATE PROCEDURE `sp_Report_StudentPaymentDetails` (
  IN `p_OrganizationId` INT,
  IN `p_StudentId` INT,
  IN `p_SessionId` INT
)
BEGIN
  SET p_SessionId = NULLIF(p_SessionId, 0);

  SELECT
    p.PaymentId,
    p.ReceiptNo,
    p.PaymentDate,
    p.PaymentMode,
    p.PaymentTarget,
    p.TotalPaidAmount,
    p.ReferenceNo,
    p.Notes,
    p.SessionId
  FROM FeePayment p
  WHERE p.OrganizationId = p_OrganizationId
    AND p.StudentId = p_StudentId
    AND (p_SessionId IS NULL OR p.SessionId = p_SessionId OR p.SessionId IS NULL)
  ORDER BY p.PaymentDate DESC, p.PaymentId DESC;
END$$

DELIMITER ;
