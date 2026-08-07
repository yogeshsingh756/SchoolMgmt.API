-- Seed: Admission Prefixes under Class Management (idempotent)
-- Sidebar tab id = admission-prefixes

SET @moduleId := (
  SELECT ModuleId
  FROM Modules
  WHERE ModuleName = 'Class Management'
  LIMIT 1
);

SET @moduleId := IFNULL(@moduleId, (
  SELECT m.ModuleId
  FROM Modules m
  INNER JOIN SubModules sm ON sm.ModuleId = m.ModuleId
  WHERE sm.SubModuleName IN ('Sections', 'Classes', 'Class')
  LIMIT 1
));

SET @moduleName := (SELECT ModuleName FROM Modules WHERE ModuleId = @moduleId LIMIT 1);

INSERT INTO SubModules (ModuleId, SubModuleName, Description, RoutePath, OrderNo, IsActive, CreatedBy, CreatedOn)
SELECT @moduleId, 'Admission Prefixes', 'Class admission number prefix mapping', '/admission-prefixes', 50, 1, 1, NOW()
WHERE @moduleId IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM SubModules
    WHERE ModuleId = @moduleId AND SubModuleName = 'Admission Prefixes'
  );

SET @subModuleId := (
  SELECT SubModuleId FROM SubModules
  WHERE SubModuleName = 'Admission Prefixes' AND (@moduleId IS NULL OR ModuleId = @moduleId)
  ORDER BY SubModuleId DESC
  LIMIT 1
);

INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, SubModuleId, ModuleName, Description, IsActive, CreatedOn)
SELECT CONCAT(@moduleName, '.Admission Prefixes.View'), 'View Admission Prefixes', @moduleId, @subModuleId, @moduleName, 'View Admission Prefixes', 1, NOW()
WHERE @subModuleId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM Permissions WHERE PermissionKey = CONCAT(@moduleName, '.Admission Prefixes.View'));

INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, SubModuleId, ModuleName, Description, IsActive, CreatedOn)
SELECT CONCAT(@moduleName, '.Admission Prefixes.Create'), 'Create Admission Prefixes', @moduleId, @subModuleId, @moduleName, 'Create Admission Prefixes', 1, NOW()
WHERE @subModuleId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM Permissions WHERE PermissionKey = CONCAT(@moduleName, '.Admission Prefixes.Create'));

INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, SubModuleId, ModuleName, Description, IsActive, CreatedOn)
SELECT CONCAT(@moduleName, '.Admission Prefixes.Edit'), 'Edit Admission Prefixes', @moduleId, @subModuleId, @moduleName, 'Edit Admission Prefixes', 1, NOW()
WHERE @subModuleId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM Permissions WHERE PermissionKey = CONCAT(@moduleName, '.Admission Prefixes.Edit'));

INSERT INTO Permissions (PermissionKey, PermissionName, ModuleId, SubModuleId, ModuleName, Description, IsActive, CreatedOn)
SELECT CONCAT(@moduleName, '.Admission Prefixes.Delete'), 'Delete Admission Prefixes', @moduleId, @subModuleId, @moduleName, 'Delete Admission Prefixes', 1, NOW()
WHERE @subModuleId IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM Permissions WHERE PermissionKey = CONCAT(@moduleName, '.Admission Prefixes.Delete'));

-- Grant to Admin / School Admin style roles that already have Sections access
INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
SELECT DISTINCT rp.RoleId, p.PermissionId, 1, 1, 1, 1, NOW()
FROM Permissions p
CROSS JOIN (
  SELECT DISTINCT RoleId
  FROM RolePermissions rp2
  INNER JOIN Permissions p2 ON p2.PermissionId = rp2.PermissionId
  INNER JOIN SubModules sm2 ON sm2.SubModuleId = p2.SubModuleId
  WHERE sm2.SubModuleName IN ('Sections', 'Classes')
    AND rp2.CanView = 1
) rp
WHERE p.SubModuleId = @subModuleId
  AND NOT EXISTS (
    SELECT 1 FROM RolePermissions x
    WHERE x.RoleId = rp.RoleId AND x.PermissionId = p.PermissionId
  );
