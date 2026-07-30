-- Procedure: sp_Report_DailyCollection
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Report_DailyCollection`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Report_DailyCollection` (IN `p_OrganizationId` INT, IN `p_FromDate` DATE, IN `p_ToDate` DATE, IN `p_PaymentMode` VARCHAR(20))   BEGIN
  -- default dates if caller passed NULL (optional behaviour)
  SET p_FromDate = IFNULL(p_FromDate, CURDATE());
  SET p_ToDate   = IFNULL(p_ToDate, CURDATE());

  SELECT
    DATE(fp.PaymentDate) AS CollectionDate,
    COUNT(DISTINCT fp.PaymentId) AS PaymentsCount,
    COALESCE(SUM(fp.TotalPaidAmount), 0) AS TotalCollected,
    COALESCE(SUM(s_alloc.Allocated), 0) AS AllocatedAmount,
    COALESCE(SUM(s_alloc.Unallocated), 0) AS UnallocatedAmount
  FROM FeePayment fp
  /* aggregated allocations per payment */
  LEFT JOIN (
    SELECT
      fp2.PaymentId AS PaymentId,
      COALESCE(fp2.TotalPaidAmount,0) AS TotalPaid,
      COALESCE(SUM(fa2.AllocatedAmount),0) AS Allocated,
      COALESCE(fp2.TotalPaidAmount,0) - COALESCE(SUM(fa2.AllocatedAmount),0) AS Unallocated
    FROM FeePayment fp2
    LEFT JOIN FeePaymentAllocation fa2 ON fa2.PaymentId = fp2.PaymentId
    WHERE fp2.OrganizationId = p_OrganizationId
    GROUP BY fp2.PaymentId, fp2.TotalPaidAmount
  ) s_alloc ON s_alloc.PaymentId = fp.PaymentId
  WHERE fp.OrganizationId = p_OrganizationId
    AND DATE(fp.PaymentDate) BETWEEN p_FromDate AND p_ToDate
    AND (p_PaymentMode IS NULL OR p_PaymentMode = '' OR fp.PaymentMode = p_PaymentMode)
  GROUP BY DATE(fp.PaymentDate)
  ORDER BY DATE(fp.PaymentDate) DESC;
END$$

DELIMITER ;