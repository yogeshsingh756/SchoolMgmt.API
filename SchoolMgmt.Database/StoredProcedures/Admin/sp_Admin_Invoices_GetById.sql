-- Procedure: sp_Admin_Invoices_GetById
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Invoices_GetById`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Invoices_GetById` (IN `p_OrganizationId` INT, IN `p_InvoiceId` INT)   BEGIN
    /* 1️⃣ INVOICE HEADER DETAILS */
    SELECT 
        i.InvoiceId,
        i.InvoiceNo,
        i.StudentId,
        s.AdmissionNo,
        CONCAT(u.FirstName, ' ', u.LastName) AS StudentName,
        u.FirstName,
        u.LastName,
        u.Email,
        u.Phone,
        i.InvoiceDate,
        i.DueDate,
        i.TermId,
        i.SessionId,
        i.TotalAmount,
        i.TotalDiscount,
        i.NetPayable,
        i.PaidAmount,
        i.BalanceAmount,
        i.Status,
        i.Notes
    FROM StudentFeeInvoice i
    INNER JOIN Students s ON s.StudentId = i.StudentId
    INNER JOIN Users u ON u.UserId = s.UserId
    WHERE i.OrganizationId = p_OrganizationId
      AND i.InvoiceId = p_InvoiceId
      AND i.IsDeleted = 0;

    /* 2️⃣ INVOICE ITEMS */
    SELECT 
        ii.InvoiceItemId,
        ii.FeeTypeId,
        ft.FeeTypeName,
        ii.Amount,
        ii.DiscountAmount,
        ii.NetAmount,
        ii.PaidAmount
    FROM StudentFeeInvoiceItem ii
    INNER JOIN FeeTypes ft 
        ON ft.FeeTypeId = ii.FeeTypeId
    WHERE ii.OrganizationId = p_OrganizationId
      AND ii.InvoiceId = p_InvoiceId
      AND ii.IsDeleted = 0;

    /* 3️⃣ PAYMENT ALLOCATIONS (Partial Payments / Installments) */
    SELECT 
        fa.AllocationId,
        fa.PaymentId,
        fp.ReceiptNo,
        fa.InvoiceItemId,
        fa.AllocatedAmount,
        fp.PaymentDate,
        fp.PaymentMode,
        fp.ReferenceNo,
        fp.TotalPaidAmount
    FROM FeePaymentAllocation fa
    INNER JOIN FeePayment fp
        ON fp.PaymentId = fa.PaymentId
    WHERE fa.OrganizationId = p_OrganizationId
      AND fa.InvoiceId = p_InvoiceId
    ORDER BY fp.PaymentDate ASC;
END$$

DELIMITER ;