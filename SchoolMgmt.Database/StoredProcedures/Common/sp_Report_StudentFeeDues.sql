-- Procedure: sp_Report_StudentFeeDues
-- classId/sectionId optional; search + from/to payment date filters;
-- flat StudentConcession reduces yearly net; aggregate includes ConcessionTotal

DROP PROCEDURE IF EXISTS `sp_Report_StudentFeeDues`;

DELIMITER $$

CREATE PROCEDURE `sp_Report_StudentFeeDues` (
  IN `p_OrganizationId` INT,
  IN `p_ClassId` INT,
  IN `p_SectionId` INT,
  IN `p_SessionId` INT,
  IN `p_PageNumber` INT,
  IN `p_PageSize` INT,
  IN `p_Search` VARCHAR(100),
  IN `p_FromDate` DATE,
  IN `p_ToDate` DATE
)
BEGIN
  DECLARE v_PageNumber INT DEFAULT 1;
  DECLARE v_PageSize INT DEFAULT 10;
  DECLARE v_Offset INT DEFAULT 0;

  SET p_ClassId = NULLIF(p_ClassId, 0);
  SET p_SectionId = NULLIF(p_SectionId, 0);
  SET p_SessionId = NULLIF(p_SessionId, 0);
  SET p_Search = IFNULL(TRIM(p_Search), '');
  SET v_PageNumber = IFNULL(NULLIF(p_PageNumber, 0), 1);
  SET v_PageSize = IFNULL(NULLIF(p_PageSize, 0), 10);
  SET v_Offset = (v_PageNumber - 1) * v_PageSize;

  DROP TEMPORARY TABLE IF EXISTS tmp_StudentFeeDues;
  CREATE TEMPORARY TABLE tmp_StudentFeeDues AS
  SELECT
    u.UserId AS StudentId,
    CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) AS StudentName,
    s.AdmissionNo,
    c.ClassName,
    sec.SectionName,
    IFNULL(sc.Amount, 0) AS ConcessionAmount,
    GREATEST(IFNULL(yf.YearlyTotal, 0) - IFNULL(sc.Amount, 0), 0) AS YearlyFeeTotal,
    IFNULL(tp.TermFeePaid, 0) AS TermFeePaid,
    GREATEST(GREATEST(IFNULL(yf.YearlyTotal, 0) - IFNULL(sc.Amount, 0), 0) - IFNULL(tp.TermFeePaid, 0), 0) AS TermFeeLeft,
    IFNULL(ofee.TotalAmount, 0) AS OldFeeTotal,
    IFNULL(
      CASE
        WHEN p_FromDate IS NOT NULL OR p_ToDate IS NOT NULL THEN IFNULL(op.OldFeePaid, 0)
        ELSE IFNULL(ofee.PaidAmount, 0)
      END,
      0
    ) AS OldFeePaid,
    GREATEST(
      IFNULL(ofee.TotalAmount, 0) - IFNULL(
        CASE
          WHEN p_FromDate IS NOT NULL OR p_ToDate IS NOT NULL THEN IFNULL(op.OldFeePaid, 0)
          ELSE IFNULL(ofee.PaidAmount, 0)
        END,
        0
      ),
      0
    ) AS OldFeeLeft
  FROM Students s
  INNER JOIN Users u ON u.UserId = s.UserId
  LEFT JOIN Classes c ON c.ClassId = s.CurrentClassId
  LEFT JOIN Sections sec ON sec.SectionId = s.CurrentSectionId
  LEFT JOIN (
    SELECT ClassId, SectionId, SUM(Amount) AS YearlyTotal
    FROM ClassFeeMaster
    WHERE OrganizationId = p_OrganizationId AND IsDeleted = 0 AND IsActive = 1
      AND (p_SessionId IS NULL OR SessionId = p_SessionId)
    GROUP BY ClassId, SectionId
  ) yf ON yf.ClassId = s.CurrentClassId
      AND (
        (s.CurrentSectionId IS NULL AND yf.SectionId IS NULL)
        OR yf.SectionId = s.CurrentSectionId
        OR (yf.SectionId IS NULL AND NOT EXISTS (
              SELECT 1 FROM ClassFeeMaster x
              WHERE x.OrganizationId = p_OrganizationId AND x.ClassId = s.CurrentClassId
                AND x.SectionId = s.CurrentSectionId AND x.IsDeleted = 0 AND x.IsActive = 1
                AND (p_SessionId IS NULL OR x.SessionId = p_SessionId)
            ))
      )
  LEFT JOIN (
    SELECT StudentId, SUM(TotalPaidAmount) AS TermFeePaid
    FROM FeePayment
    WHERE OrganizationId = p_OrganizationId AND PaymentTarget = 'TermFee'
      AND (p_SessionId IS NULL OR SessionId = p_SessionId OR SessionId IS NULL)
      AND (p_FromDate IS NULL OR DATE(PaymentDate) >= p_FromDate)
      AND (p_ToDate IS NULL OR DATE(PaymentDate) <= p_ToDate)
    GROUP BY StudentId
  ) tp ON tp.StudentId = u.UserId
  LEFT JOIN StudentConcession sc
    ON sc.StudentId = u.UserId AND sc.OrganizationId = p_OrganizationId AND sc.IsDeleted = 0 AND IFNULL(sc.IsActive,1) = 1
  LEFT JOIN StudentOldFee ofee
    ON ofee.StudentId = u.UserId AND ofee.OrganizationId = p_OrganizationId AND ofee.IsDeleted = 0
  LEFT JOIN (
    SELECT StudentId, SUM(TotalPaidAmount) AS OldFeePaid
    FROM FeePayment
    WHERE OrganizationId = p_OrganizationId AND PaymentTarget = 'OldFee'
      AND (p_FromDate IS NULL OR DATE(PaymentDate) >= p_FromDate)
      AND (p_ToDate IS NULL OR DATE(PaymentDate) <= p_ToDate)
    GROUP BY StudentId
  ) op ON op.StudentId = u.UserId
  WHERE s.OrganizationId = p_OrganizationId
    AND s.IsDeleted = 0
    AND IFNULL(u.IsDeleted,0) = 0
    AND (p_ClassId IS NULL OR s.CurrentClassId = p_ClassId)
    AND (p_SectionId IS NULL OR s.CurrentSectionId = p_SectionId)
    AND (
      p_Search = ''
      OR s.AdmissionNo LIKE CONCAT('%', p_Search, '%')
      OR u.FirstName LIKE CONCAT('%', p_Search, '%')
      OR u.LastName LIKE CONCAT('%', p_Search, '%')
      OR CONCAT(u.FirstName, ' ', IFNULL(u.LastName, '')) LIKE CONCAT('%', p_Search, '%')
    );

  SELECT SQL_CALC_FOUND_ROWS
    StudentId,
    StudentName,
    AdmissionNo,
    ClassName,
    SectionName,
    ConcessionAmount,
    YearlyFeeTotal,
    TermFeePaid,
    TermFeeLeft,
    OldFeeTotal,
    OldFeePaid,
    OldFeeLeft
  FROM tmp_StudentFeeDues
  ORDER BY StudentId DESC
  LIMIT v_Offset, v_PageSize;

  SELECT FOUND_ROWS() AS TotalRows;

  SELECT
    IFNULL(SUM(ConcessionAmount), 0) AS ConcessionTotal,
    IFNULL(SUM(YearlyFeeTotal), 0) AS YearlyFeeTotal,
    IFNULL(SUM(TermFeePaid), 0) AS TermFeePaid,
    IFNULL(SUM(TermFeeLeft), 0) AS TermFeeLeft,
    IFNULL(SUM(OldFeeTotal), 0) AS OldFeeTotal,
    IFNULL(SUM(OldFeePaid), 0) AS OldFeePaid,
    IFNULL(SUM(OldFeeLeft), 0) AS OldFeeLeft,
    IFNULL(SUM(YearlyFeeTotal), 0) + IFNULL(SUM(OldFeeTotal), 0) AS SchoolFeeTotal,
    IFNULL(SUM(TermFeePaid), 0) + IFNULL(SUM(OldFeePaid), 0) AS SchoolFeePaid,
    IFNULL(SUM(TermFeeLeft), 0) + IFNULL(SUM(OldFeeLeft), 0) AS SchoolFeeLeft
  FROM tmp_StudentFeeDues;

  DROP TEMPORARY TABLE IF EXISTS tmp_StudentFeeDues;
END$$

DELIMITER ;
