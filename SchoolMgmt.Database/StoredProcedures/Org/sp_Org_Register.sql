-- Procedure: sp_Org_Register
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Org_Register`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Org_Register` (IN `p_SchoolName` VARCHAR(150), IN `p_Address` VARCHAR(255), IN `p_Phone` VARCHAR(20), IN `p_Email` VARCHAR(100), IN `p_PlanId` INT, IN `p_IsTrial` TINYINT(1), IN `p_TrialDays` INT, IN `p_AdminFirstName` VARCHAR(100), IN `p_AdminLastName` VARCHAR(100), IN `p_AdminUsername` VARCHAR(50), IN `p_AdminEmail` VARCHAR(100), IN `p_AdminPasswordHash` VARCHAR(255), IN `p_CreatedBy` INT, IN `p_AdminPhone` VARCHAR(20), IN `p_LogoUrl` LONGTEXT, OUT `o_OrganizationId` INT, OUT `o_AdminUserId` INT, OUT `o_Status` VARCHAR(50))   BEGIN
  -- ✅ DECLARE ALL VARIABLES FIRST
  DECLARE v_AdminRoleId INT DEFAULT NULL;
  DECLARE v_PlanBilling VARCHAR(20);
  DECLARE v_CustomMonths INT DEFAULT NULL;
  DECLARE v_ExpiresAt DATETIME DEFAULT NULL;

  -- ✅ Error handling
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET o_OrganizationId = NULL;
    SET o_AdminUserId = NULL;
    SET o_Status = 'ERROR';
  END;

  START TRANSACTION;

  -- ✅ 1️⃣ Insert organization
  INSERT INTO Organizations (SchoolName, Address, Phone, Email, SubscriptionPlanId, IsTrial, TrialExpiresAt, CreatedBy, LogoUrl)
  VALUES (
    p_SchoolName,
    p_Address,
    p_Phone,
    p_Email,
    p_PlanId,
    p_IsTrial,
    CASE WHEN p_IsTrial = 1 THEN DATE_ADD(NOW(), INTERVAL p_TrialDays DAY) ELSE NULL END,
    p_CreatedBy,
    p_LogoUrl
  );

  SET o_OrganizationId = LAST_INSERT_ID();

  -- ✅ 2️⃣ Get or create Admin Role
  SELECT RoleId INTO v_AdminRoleId FROM Roles WHERE RoleName = 'Admin' LIMIT 1;

  IF v_AdminRoleId IS NULL THEN
    INSERT INTO Roles (RoleName) VALUES ('Admin');
    SET v_AdminRoleId = LAST_INSERT_ID();
  END IF;

  -- ✅ 3️⃣ Create admin user
  INSERT INTO Users (OrganizationId, RoleId, FirstName, LastName, Email, Username, PasswordHash, Phone, IsActive)
  VALUES (o_OrganizationId, v_AdminRoleId, p_AdminFirstName, p_AdminLastName, p_AdminEmail, p_AdminUsername, p_AdminPasswordHash, p_AdminPhone, 1);

  SET o_AdminUserId = LAST_INSERT_ID();

  -- ✅ 4️⃣ Add mapping in UserRoles
  INSERT INTO UserRoles (UserId, RoleId) VALUES (o_AdminUserId, v_AdminRoleId);

  -- ???? NEW: Ensure RolePermissions are initialized for Admin Role (Full CRUD)
  INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
  SELECT v_AdminRoleId, p.PermissionId, 1, 1, 1, 1, NOW()
  FROM Permissions p
  WHERE p.IsActive = 1
    AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
    AND NOT EXISTS (
        SELECT 1 FROM RolePermissions rp
        WHERE rp.RoleId = v_AdminRoleId AND rp.PermissionId = p.PermissionId
    );
  -- ???? 6️⃣ Map all roles (except SuperAdmin & Admin) to AdminUserId in AdminRoleScope
  INSERT INTO AdminRoleScope (AdminUserId, AllowedRoleId, CreatedBy, CreatedOn)
  SELECT o_AdminUserId, r.RoleId, o_AdminUserId, NOW()
  FROM Roles r
  WHERE r.RoleName NOT IN ('SuperAdmin', 'Admin')
    AND (r.IsDeleted = 0 OR r.IsDeleted IS NULL);
  -- ❌ REMOVED:
  -- UPDATE Modules SET IsActive = 1 WHERE IsActive IS NULL;
  -- UPDATE SubModules SET IsActive = 1 WHERE IsActive IS NULL;
  -- (You will manage activation manually)

  -- ✅ 5️⃣ Handle subscription if plan selected
  IF p_PlanId IS NOT NULL THEN
    SELECT BillingCycle, CustomMonths INTO v_PlanBilling, v_CustomMonths
    FROM SubscriptionPlans WHERE PlanId = p_PlanId LIMIT 1;

    IF v_PlanBilling = 'OneTime' THEN
      SET v_ExpiresAt = DATE_ADD(NOW(), INTERVAL 100 YEAR);
    ELSEIF v_PlanBilling = 'Monthly' THEN
      SET v_ExpiresAt = DATE_ADD(NOW(), INTERVAL 1 MONTH);
    ELSEIF v_PlanBilling = 'Quarterly' THEN
      SET v_ExpiresAt = DATE_ADD(NOW(), INTERVAL 3 MONTH);
    ELSEIF v_PlanBilling = 'SemiAnnual' THEN
      SET v_ExpiresAt = DATE_ADD(NOW(), INTERVAL 6 MONTH);
    ELSEIF v_PlanBilling = 'Yearly' THEN
      SET v_ExpiresAt = DATE_ADD(NOW(), INTERVAL 12 MONTH);
    ELSEIF v_PlanBilling = 'Custom' THEN
      IF v_CustomMonths IS NOT NULL THEN
        SET v_ExpiresAt = DATE_ADD(NOW(), INTERVAL v_CustomMonths MONTH);
      END IF;
    END IF;

    INSERT INTO TenantSubscriptions (OrganizationId, PlanId, StartedAt, ExpiresAt, IsTrial, STATUS)
    VALUES (o_OrganizationId, p_PlanId, NOW(), v_ExpiresAt, p_IsTrial, 'Active');
  END IF;

  COMMIT;
  SET o_Status = 'OK';
END$$

DELIMITER ;