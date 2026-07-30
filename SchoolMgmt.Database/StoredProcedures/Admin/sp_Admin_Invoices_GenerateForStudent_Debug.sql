-- Procedure: sp_Admin_Invoices_GenerateForStudent_Debug
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Invoices_GenerateForStudent_Debug`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Invoices_GenerateForStudent_Debug` (IN `p_OrganizationId` INT, IN `p_StudentId` INT, IN `p_ClassId` INT, IN `p_TermId` INT, IN `p_SessionId` INT, IN `p_InvoiceDate` DATE, IN `p_DueDate` DATE, IN `p_Notes` VARCHAR(255), IN `p_CreatedBy` INT)   BEGIN
    DECLARE v_InvoiceId INT;
    DECLARE v_InvoiceNo VARCHAR(50);

    -- ✅ 1. Show Incoming Data
    SELECT 'INPUT PARAMS' AS DebugPoint,
           p_OrganizationId AS OrgId, 
           p_StudentId AS StudentId,
           p_ClassId AS ClassId,
           p_TermId AS TermId,
           p_SessionId AS SessionId,
           p_InvoiceDate AS InvoiceDate,
           p_DueDate AS DueDate;

    -- ✅ 2. Debug: Student Exists?
    SELECT 'STUDENT CHECK' AS DebugPoint, s.StudentId, s.UserId, s.OrganizationId
    FROM Students s
    WHERE s.StudentId = p_StudentId
      AND s.OrganizationId = p_OrganizationId;

    -- ✅ 3. Debug: Class Exists?
    SELECT 'CLASS CHECK' AS DebugPoint, c.ClassId, c.OrganizationId
    FROM Classes c
    WHERE c.ClassId = p_ClassId
      AND c.OrganizationId = p_OrganizationId;

    -- ✅ 4. Debug: Fees Assigned to Class?
    SELECT 'CLASS FEE FOUND' AS DebugPoint, cfm.ClassFeeId, cfm.FeeTypeId, cfm.Amount
    FROM ClassFeeMaster cfm
    WHERE cfm.OrganizationId = p_OrganizationId
      AND cfm.ClassId = p_ClassId
      AND (cfm.TermId <=> p_TermId)
      AND (cfm.SessionId <=> p_SessionId)
      AND cfm.IsActive = 1
      AND cfm.IsDeleted = 0;

    -- ✅ 5. Generate Invoice Number
    SET v_InvoiceNo = CONCAT(DATE_FORMAT(p_InvoiceDate,'%Y%m'), LPAD(FLOOR(RAND()*90000)+10000,5,'0'));

    -- ✅ 6. Insert into Invoice Table
    INSERT INTO StudentFeeInvoice
    (
      OrganizationId, StudentId, InvoiceNo, TermId, SessionId,
      InvoiceDate, DueDate, Notes, CreatedBy
    )
    VALUES
    (
      p_OrganizationId, p_StudentId, v_InvoiceNo, p_TermId, p_SessionId,
      p_InvoiceDate, p_DueDate, p_Notes, p_CreatedBy
    );

    SET v_InvoiceId = LAST_INSERT_ID();

    -- ✅ 7. Insert Invoice Items
    INSERT INTO StudentFeeInvoiceItem
      (OrganizationId, InvoiceId, FeeTypeId, Amount, DiscountAmount, NetAmount)
    SELECT
      cfm.OrganizationId, v_InvoiceId, cfm.FeeTypeId, cfm.Amount,
      0 AS DiscountAmount,
      cfm.Amount AS NetAmount
    FROM ClassFeeMaster cfm
    WHERE cfm.OrganizationId = p_OrganizationId
      AND cfm.ClassId = p_ClassId
      AND (cfm.TermId <=> p_TermId)
      AND (cfm.SessionId <=> p_SessionId)
      AND cfm.IsActive = 1
      AND cfm.IsDeleted = 0;

    -- ✅ 8. Debug: Show inserted items
    SELECT 
        'INVOICE ITEMS INSERTED' AS DebugPoint,
        InvoiceItemId, OrganizationId, InvoiceId, FeeTypeId, Amount, DiscountAmount, NetAmount
    FROM StudentFeeInvoiceItem
    WHERE InvoiceId = v_InvoiceId;

    -- ✅ 9. Return Invoice Details
    SELECT v_InvoiceId AS InvoiceId, v_InvoiceNo AS InvoiceNo;

END$$

DELIMITER ;