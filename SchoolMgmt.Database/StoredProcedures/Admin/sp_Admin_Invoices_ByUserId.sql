-- Procedure: sp_Admin_Invoices_ByUserId
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Invoices_ByUserId`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Invoices_ByUserId` (IN `p_OrganizationId` INT, IN `p_UserId` INT)   BEGIN
    DECLARE v_StudentId INT;


    SELECT s.StudentId INTO v_StudentId
    FROM Students s
    WHERE s.UserId = p_UserId
      AND s.OrganizationId = p_OrganizationId
      AND IFNULL(s.IsDeleted,0) = 0
    LIMIT 1;


    IF v_StudentId IS NULL THEN
        SELECT 
            NULL AS InvoiceId,
            'No Student Found' AS Message;
    ELSE


        SELECT 
            i.InvoiceId,
            i.InvoiceNo,
            i.StudentId,
            CONCAT(u.FirstName,' ',u.LastName) AS StudentName,
            i.InvoiceDate,
            i.DueDate,
            i.TotalAmount,
            i.TotalDiscount,
            i.NetPayable,
            i.PaidAmount,
            i.BalanceAmount,
            i.Status

        FROM StudentFeeInvoice i
        INNER JOIN Students s ON s.StudentId = i.StudentId
        INNER JOIN Users u ON u.UserId = s.UserId

        WHERE i.OrganizationId = p_OrganizationId
          AND i.StudentId = v_StudentId
          AND i.IsDeleted = 0


          AND (
                i.Status <> 'Paid'
                OR IFNULL(i.BalanceAmount,0) > 0
              )

        ORDER BY i.InvoiceDate DESC, i.InvoiceId DESC;

    END IF;

END$$

DELIMITER ;