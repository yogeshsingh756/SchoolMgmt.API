-- Procedure: sp_Report_StudentOutstanding_All
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Report_StudentOutstanding_All`;

DELIMITER $$

CREATE PROCEDURE `sp_Report_StudentOutstanding_All` (IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_Search` VARCHAR(100))   BEGIN
    /*
      Returns per-student outstanding summary for the given organization.
      - If p_ClassId IS NULL or 0 => ignore class filter.
      - If p_Search IS NULL or empty => ignore search filter.
      Columns:
        StudentId, UserId, AdmissionNo, StudentName, CurrentClassId,
        TotalInvoiced, TotalPaid, Outstanding
    */

    -- Normalize search param
    SET p_Search = IFNULL(NULLIF(TRIM(p_Search), ''), NULL);

    SELECT
        s.StudentId,
        u.UserId,
        s.AdmissionNo,
        CONCAT(u.FirstName, ' ', u.LastName) AS StudentName,
        s.CurrentClassId,
        IFNULL(SUM(ii.NetAmount), 0.00) AS TotalInvoiced,
        IFNULL(SUM(ii.PaidAmount), 0.00) AS TotalPaid,
        (IFNULL(SUM(ii.NetAmount), 0.00) - IFNULL(SUM(ii.PaidAmount), 0.00)) AS Outstanding
    FROM Students s
    INNER JOIN Users u ON u.UserId = s.UserId AND u.IsDeleted = 0
    LEFT JOIN StudentFeeInvoice inv
        ON inv.StudentId = s.StudentId
        AND inv.OrganizationId = p_OrganizationId
        AND inv.IsDeleted = 0
    LEFT JOIN StudentFeeInvoiceItem ii
        ON ii.InvoiceId = inv.InvoiceId
        AND ii.OrganizationId = p_OrganizationId
        AND ii.IsDeleted = 0
    WHERE s.OrganizationId = p_OrganizationId
      AND s.IsDeleted = 0
      /* class filter (optional) */
      AND (p_ClassId IS NULL OR p_ClassId = 0 OR s.CurrentClassId = p_ClassId)
      /* search filter (optional) */
      AND (
          p_Search IS NULL
          OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%')
          OR u.FirstName LIKE CONCAT('%', p_Search, '%')
          OR u.LastName LIKE CONCAT('%', p_Search, '%')
          OR u.Username LIKE CONCAT('%', p_Search, '%')
          OR u.Email LIKE CONCAT('%', p_Search, '%')
          OR u.Phone LIKE CONCAT('%', p_Search, '%')
      )
    GROUP BY s.StudentId, u.UserId, s.AdmissionNo, StudentName, s.CurrentClassId
    ORDER BY StudentName;
END$$

DELIMITER ;