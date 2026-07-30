-- Procedure: sp_Admin_Payments_CreateAndAllocate
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Payments_CreateAndAllocate`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Payments_CreateAndAllocate` (IN `p_OrganizationId` INT, IN `p_StudentId` INT, IN `p_PaymentDate` DATETIME, IN `p_PaymentMode` VARCHAR(20), IN `p_ReferenceNo` VARCHAR(50), IN `p_Notes` VARCHAR(255), IN `p_TotalPaidAmount` DECIMAL(10,2), IN `p_CreatedBy` INT)   BEGIN
  DECLARE v_PaymentId INT;
  DECLARE v_ReceiptNo VARCHAR(50);
  DECLARE v_left DECIMAL(10,2);

  INSERT INTO ReceiptSequence (OrganizationId, LastNumber)
  VALUES (p_OrganizationId, 1)
  ON DUPLICATE KEY UPDATE LastNumber = LastNumber + 1, ModifiedOn = NOW();

  SELECT LastNumber INTO @seq 
  FROM ReceiptSequence 
  WHERE OrganizationId = p_OrganizationId;

  SET v_ReceiptNo = CONCAT('RCPT-', DATE_FORMAT(p_PaymentDate,'%Y%m'), '-', LPAD(@seq,6,'0'));

  INSERT INTO FeePayment
    (OrganizationId, StudentId, ReceiptNo, PaymentDate, PaymentMode, ReferenceNo, Notes, TotalPaidAmount, CreatedBy)
  VALUES
    (p_OrganizationId, p_StudentId, v_ReceiptNo, p_PaymentDate, p_PaymentMode, p_ReferenceNo, p_Notes, p_TotalPaidAmount, p_CreatedBy);

  SET v_PaymentId = LAST_INSERT_ID();
  SET v_left = p_TotalPaidAmount;

  CREATE TEMPORARY TABLE tmp_open_items
  SELECT ii.InvoiceId, ii.InvoiceItemId,
         (ii.NetAmount - ii.PaidAmount) AS Due,
         i.InvoiceDate
  FROM StudentFeeInvoiceItem ii
  INNER JOIN StudentFeeInvoice i ON i.InvoiceId = ii.InvoiceId
  WHERE ii.OrganizationId = p_OrganizationId
    AND i.StudentId = p_StudentId
    AND ii.IsDeleted = 0
    AND i.IsDeleted = 0
    AND (ii.NetAmount - ii.PaidAmount) > 0
  ORDER BY i.InvoiceDate ASC, ii.InvoiceItemId ASC;

  WHILE v_left > 0 AND EXISTS (SELECT 1 FROM tmp_open_items LIMIT 1) DO
    SELECT InvoiceId, InvoiceItemId, Due INTO @invId, @itemId, @due
    FROM tmp_open_items ORDER BY InvoiceDate ASC, InvoiceItemId ASC LIMIT 1;

    SET @alloc := LEAST(v_left, @due);

    INSERT INTO FeePaymentAllocation (OrganizationId, PaymentId, InvoiceId, InvoiceItemId, AllocatedAmount)
    VALUES (p_OrganizationId, v_PaymentId, @invId, @itemId, @alloc);

    UPDATE StudentFeeInvoiceItem
       SET PaidAmount = PaidAmount + @alloc
     WHERE InvoiceItemId = @itemId;

    SELECT IFNULL(SUM(NetAmount),0), IFNULL(SUM(PaidAmount),0) INTO @sumNet, @sumPaid
    FROM StudentFeeInvoiceItem
    WHERE InvoiceId = @invId AND IsDeleted = 0;

    UPDATE StudentFeeInvoice
       SET PaidAmount = @sumPaid,
           BalanceAmount = GREATEST(@sumNet - @sumPaid, 0),
           Status = CASE 
                      WHEN @sumPaid = 0 THEN 'Pending'
                      WHEN @sumPaid < @sumNet THEN 'PartiallyPaid'
                      ELSE 'Paid'
                    END
     WHERE InvoiceId = @invId;

    SET v_left = v_left - @alloc;
    DELETE FROM tmp_open_items WHERE InvoiceItemId = @itemId;
  END WHILE;

  DROP TEMPORARY TABLE IF EXISTS tmp_open_items;

  SELECT v_PaymentId AS PaymentId, v_ReceiptNo AS ReceiptNo, (p_TotalPaidAmount - v_left) AS Allocated, v_left AS Unallocated;
END$$

DELIMITER ;