-- Procedure: sp_Admin_StudentFeeBalances_ByClass
-- Students in class/section with yearly fee totals (net of flat concession) and old fee balances

DROP PROCEDURE IF EXISTS `sp_Admin_StudentFeeBalances_ByClass`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_StudentFeeBalances_ByClass` (
  IN `p_OrganizationId` INT,
  IN `p_ClassId` INT,
  IN `p_SectionId` INT,
  IN `p_SessionId` INT,
  IN `p_Search` VARCHAR(100)
)
BEGIN
  SET p_SectionId = NULLIF(p_SectionId, 0);
  SET p_SessionId = NULLIF(p_SessionId, 0);
  SET p_Search = IFNULL(TRIM(p_Search), '');

  SELECT
    u.UserId AS StudentId,
    s.StudentId AS StudentPk,
    CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS StudentName,
    s.AdmissionNo,
    s.CurrentClassId AS ClassId,
    c.ClassName,
    s.CurrentSectionId AS SectionId,
    sec.SectionName,
    IFNULL(sc.Amount, 0) AS ConcessionAmount,
    GREATEST(IFNULL(yf.YearlyTotal, 0) - IFNULL(sc.Amount, 0), 0) AS YearlyTotal,
    IFNULL(tp.TermFeePaid, 0) AS TermFeePaid,
    GREATEST(GREATEST(IFNULL(yf.YearlyTotal, 0) - IFNULL(sc.Amount, 0), 0) - IFNULL(tp.TermFeePaid, 0), 0) AS TermFeeLeft,
    ofee.OldFeeId,
    IFNULL(ofee.TotalAmount, 0) AS OldFeeTotal,
    IFNULL(ofee.PaidAmount, 0) AS OldFeePaid,
    GREATEST(IFNULL(ofee.TotalAmount, 0) - IFNULL(ofee.PaidAmount, 0), 0) AS OldFeeLeft
  FROM Students s
  INNER JOIN Users u ON u.UserId = s.UserId AND u.OrganizationId = s.OrganizationId
  LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId
  LEFT JOIN Sections sec ON sec.SectionId = s.CurrentSectionId
  LEFT JOIN (
    SELECT
      cfm.ClassId,
      cfm.SectionId,
      SUM(cfm.Amount) AS YearlyTotal
    FROM ClassFeeMaster cfm
    WHERE cfm.OrganizationId = p_OrganizationId
      AND cfm.IsDeleted = 0
      AND cfm.IsActive = 1
      AND (p_SessionId IS NULL OR cfm.SessionId = p_SessionId)
    GROUP BY cfm.ClassId, cfm.SectionId
  ) yf ON yf.ClassId = s.CurrentClassId
      AND (
        (s.CurrentSectionId IS NULL AND yf.SectionId IS NULL)
        OR yf.SectionId = s.CurrentSectionId
        OR (s.CurrentSectionId IS NOT NULL AND yf.SectionId IS NULL
            AND NOT EXISTS (
              SELECT 1 FROM ClassFeeMaster x
              WHERE x.OrganizationId = p_OrganizationId
                AND x.ClassId = s.CurrentClassId
                AND x.SectionId = s.CurrentSectionId
                AND x.IsDeleted = 0 AND x.IsActive = 1
                AND (p_SessionId IS NULL OR x.SessionId = p_SessionId)
            ))
      )
  LEFT JOIN (
    SELECT StudentId, SessionId, SUM(TotalPaidAmount) AS TermFeePaid
    FROM FeePayment
    WHERE OrganizationId = p_OrganizationId
      AND PaymentTarget = 'TermFee'
    GROUP BY StudentId, SessionId
  ) tp ON tp.StudentId = u.UserId
      AND (p_SessionId IS NULL OR tp.SessionId = p_SessionId OR tp.SessionId IS NULL)
  LEFT JOIN StudentConcession sc
    ON sc.StudentId = u.UserId
   AND sc.OrganizationId = p_OrganizationId
   AND sc.IsDeleted = 0
   AND IFNULL(sc.IsActive, 1) = 1
  LEFT JOIN StudentOldFee ofee
    ON ofee.StudentId = u.UserId
   AND ofee.OrganizationId = p_OrganizationId
   AND ofee.IsDeleted = 0
  WHERE s.OrganizationId = p_OrganizationId
    AND s.IsDeleted = 0
    AND IFNULL(u.IsDeleted, 0) = 0
    AND s.CurrentClassId = p_ClassId
    AND (p_SectionId IS NULL OR s.CurrentSectionId = p_SectionId)
    AND (
      p_Search = ''
      OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%')
      OR u.FirstName LIKE CONCAT('%', p_Search, '%')
      OR u.LastName LIKE CONCAT('%', p_Search, '%')
      OR CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) LIKE CONCAT('%', p_Search, '%')
    )
  ORDER BY u.FirstName, u.LastName;
END$$

DELIMITER ;
