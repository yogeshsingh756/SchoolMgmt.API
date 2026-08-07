-- Seed Payments (receipts) under Payment Management (idempotent)

SET @moduleId := (
  SELECT ModuleId FROM Modules
  WHERE ModuleName IN ('Payment Management', 'Fee Management', 'Fee Collection')
  ORDER BY CASE ModuleName
    WHEN 'Payment Management' THEN 1
    WHEN 'Fee Management' THEN 2
    ELSE 3 END
  LIMIT 1
);

SET @moduleName := (SELECT ModuleName FROM Modules WHERE ModuleId = @moduleId LIMIT 1);

INSERT INTO SubModules (ModuleId, SubModuleName, Description, RoutePath, OrderNo, IsActive, CreatedBy, CreatedOn)
SELECT @moduleId, 'Payments', 'View payments and print receipts', '/payments', 20, 1, 1, NOW()
WHERE @moduleId IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM SubModules WHERE ModuleId = @moduleId AND SubModuleName = 'Payments'
  );

SET @subModuleId := (
  SELECT SubModuleId FROM SubModules
  WHERE SubModuleName = 'Payments'
    AND (@moduleId IS NULL OR ModuleId = @moduleId)
  ORDER BY SubModuleId DESC
  LIMIT 1
);

INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, SubModuleId, ModuleName, Description, IsActive, CreatedOn)
SELECT CONCAT(@moduleName, '.Payments.View'), 'View Payments', @moduleId, @subModuleId, @moduleName, 'View Payments and Receipts', 1, NOW()
WHERE @subModuleId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM Permissions WHERE PermissionKey = CONCAT(@moduleName, '.Payments.View'));

INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
SELECT DISTINCT rp.RoleId, p.PermissionId, 1, 1, 1, 1, NOW()
FROM Permissions p
CROSS JOIN (
  SELECT DISTINCT RoleId
  FROM RolePermissions rp2
  INNER JOIN Permissions p2 ON p2.PermissionId = rp2.PermissionId
  INNER JOIN SubModules sm2 ON sm2.SubModuleId = p2.SubModuleId
  WHERE sm2.SubModuleName IN ('Collect Payment', 'Payment Methods', 'Daily Collection')
    AND rp2.CanView = 1
) rp
WHERE p.SubModuleId = @subModuleId
  AND NOT EXISTS (
    SELECT 1 FROM RolePermissions x WHERE x.RoleId = rp.RoleId AND x.PermissionId = p.PermissionId
  );
