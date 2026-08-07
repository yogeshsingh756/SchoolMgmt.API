-- Seed Student Fee Dues report under Fee Reports (idempotent)

SET @moduleId := (
  SELECT ModuleId FROM Modules WHERE ModuleName IN ('Fee Reports', 'Fee Management', 'Reports')
  ORDER BY CASE ModuleName WHEN 'Fee Reports' THEN 1 WHEN 'Fee Management' THEN 2 ELSE 3 END
  LIMIT 1
);

SET @moduleName := (SELECT ModuleName FROM Modules WHERE ModuleId = @moduleId LIMIT 1);

INSERT INTO SubModules (ModuleId, SubModuleName, Description, RoutePath, OrderNo, IsActive, CreatedBy, CreatedOn)
SELECT @moduleId, 'Student Fee Dues', 'Yearly and old fee dues by class/section', '/student-fee-dues', 60, 1, 1, NOW()
WHERE @moduleId IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM SubModules WHERE ModuleId = @moduleId AND SubModuleName = 'Student Fee Dues'
  );

SET @subModuleId := (
  SELECT SubModuleId FROM SubModules WHERE SubModuleName = 'Student Fee Dues' ORDER BY SubModuleId DESC LIMIT 1
);

INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, SubModuleId, ModuleName, Description, IsActive, CreatedOn)
SELECT CONCAT(@moduleName, '.Student Fee Dues.View'), 'View Student Fee Dues', @moduleId, @subModuleId, @moduleName, 'View Student Fee Dues', 1, NOW()
WHERE @subModuleId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM Permissions WHERE PermissionKey = CONCAT(@moduleName, '.Student Fee Dues.View'));

INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
SELECT DISTINCT rp.RoleId, p.PermissionId, 1, 1, 1, 1, NOW()
FROM Permissions p
CROSS JOIN (
  SELECT DISTINCT RoleId
  FROM RolePermissions rp2
  INNER JOIN Permissions p2 ON p2.PermissionId = rp2.PermissionId
  INNER JOIN SubModules sm2 ON sm2.SubModuleId = p2.SubModuleId
  WHERE sm2.SubModuleName IN ('Student Outstanding', 'Daily Collection', 'Collect Payment')
    AND rp2.CanView = 1
) rp
WHERE p.SubModuleId = @subModuleId
  AND NOT EXISTS (
    SELECT 1 FROM RolePermissions x WHERE x.RoleId = rp.RoleId AND x.PermissionId = p.PermissionId
  );
