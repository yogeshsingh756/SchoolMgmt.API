-- Procedure: sp_User_Create

DROP PROCEDURE IF EXISTS `sp_User_Create`;

DELIMITER $$

CREATE PROCEDURE `sp_User_Create` (
  IN `p_OrganizationId` INT,
  IN `p_RoleName` VARCHAR(50),
  IN `p_FirstName` VARCHAR(100),
  IN `p_LastName` VARCHAR(100),
  IN `p_Username` VARCHAR(50),
  IN `p_Email` VARCHAR(100),
  IN `p_PasswordHash` VARCHAR(255),
  IN `p_CreatedBy` INT,
  IN `p_PhoneNumber` VARCHAR(20),
  IN `p_Qualification` VARCHAR(150),
  IN `p_Designation` VARCHAR(100),
  IN `p_Salary` DECIMAL(10,2),
  IN `p_Occupation` VARCHAR(100),
  IN `p_Address` VARCHAR(255),
  IN `p_AdmissionNo` VARCHAR(50),
  IN `p_ParentId` INT,
  IN `p_ClassId` INT,
  IN `p_Gender` VARCHAR(100),
  IN `p_MotherName` VARCHAR(100),
  IN `p_Category` VARCHAR(100),
  IN `p_FatherName` VARCHAR(100),
  IN `p_SectionId` INT,
  IN `p_StudentType` VARCHAR(20)
)
BEGIN
    DECLARE v_RoleId INT DEFAULT NULL;
    DECLARE v_Exists INT DEFAULT 0;
    DECLARE v_RoleName VARCHAR(50);
    DECLARE v_NewUserId INT;
    DECLARE v_SectionOk INT DEFAULT 1;

    SET p_Qualification = IFNULL(p_Qualification, NULL);
    SET p_Designation = IFNULL(p_Designation, NULL);
    SET p_Salary = IFNULL(p_Salary, NULL);
    SET p_Occupation = IFNULL(p_Occupation, NULL);
    SET p_Address = IFNULL(p_Address, NULL);
    SET p_AdmissionNo = NULLIF(TRIM(IFNULL(p_AdmissionNo, '')), '');
    SET p_ClassId = NULLIF(p_ClassId, 0);
    SET p_SectionId = NULLIF(p_SectionId, 0);
    SET p_LastName = NULLIF(TRIM(IFNULL(p_LastName, '')), '');
    SET p_Gender = TRIM(IFNULL(p_Gender, ''));

    SET p_Gender =
    CASE
    WHEN p_Gender IN ('Male','Female','Other') THEN p_Gender
    ELSE NULL
    END;
    SET p_Category = NULLIF(TRIM(IFNULL(p_Category, '')), '');
    SET p_MotherName = NULLIF(TRIM(IFNULL(p_MotherName, '')), '');
    SET p_FatherName = NULLIF(TRIM(IFNULL(p_FatherName, '')), '');
    SET p_Email = NULLIF(TRIM(IFNULL(p_Email, '')), '');
    SET p_StudentType = TRIM(IFNULL(p_StudentType, 'Regular'));
    SET p_StudentType =
    CASE
      WHEN p_StudentType IN ('Regular', 'Private') THEN p_StudentType
      ELSE 'Regular'
    END;

    SELECT COUNT(*) INTO v_Exists
    FROM Users
    WHERE Username = p_Username
      OR (p_Email IS NOT NULL AND Email = p_Email);

    IF v_Exists > 0 THEN
        SELECT 0 AS SuccessFlag, 'Username or Email already exists.' AS Message;
    ELSE
        SELECT RoleId, RoleName INTO v_RoleId, v_RoleName
        FROM Roles
        WHERE RoleName = p_RoleName
        LIMIT 1;

        IF v_RoleId IS NULL THEN
            SELECT 0 AS SuccessFlag, 'Invalid role specified.' AS Message;
        ELSEIF v_RoleName IN ('SuperAdmin', 'Admin') THEN
            SELECT 0 AS SuccessFlag, 'You cannot create users with Admin or SuperAdmin roles.' AS Message;
        ELSE
            IF v_RoleName = 'Student' AND p_SectionId IS NOT NULL THEN
                SELECT COUNT(*) INTO v_SectionOk
                FROM Sections
                WHERE SectionId = p_SectionId
                  AND OrganizationId = p_OrganizationId
                  AND ClassId = p_ClassId
                  AND IFNULL(IsActive, 1) = 1;
                IF v_SectionOk = 0 THEN
                    SELECT 0 AS SuccessFlag, 'Invalid section for the selected class.' AS Message;
                END IF;
            END IF;

            IF NOT (v_RoleName = 'Student' AND p_SectionId IS NOT NULL AND v_SectionOk = 0) THEN
            INSERT INTO Users (
                OrganizationId, RoleId, FirstName, LastName,
                Username, Email, PasswordHash, Phone, Gender, Category,
                IsActive, CreatedOn, ModifiedBy, Address
            )
            VALUES (
                p_OrganizationId, v_RoleId, p_FirstName, p_LastName,
                p_Username, p_Email, p_PasswordHash, p_PhoneNumber, p_Gender, p_Category,
                1, NOW(), p_CreatedBy, p_Address
            );

            SET v_NewUserId = LAST_INSERT_ID();

            INSERT INTO UserRoles (UserId, RoleId, CreatedOn)
            VALUES (v_NewUserId, v_RoleId, NOW());

            INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
            SELECT v_RoleId, p.PermissionId, 0, 0, 0, 0, NOW()
            FROM Permissions p
            WHERE p.IsActive = 1
              AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
              AND NOT EXISTS (
                  SELECT 1 FROM RolePermissions rp
                  WHERE rp.RoleId = v_RoleId
                    AND rp.PermissionId = p.PermissionId
              );

            IF v_RoleName = 'Teacher' THEN
                INSERT INTO Teachers (
                    UserId, OrganizationId, Qualification, Designation, Salary, CreatedOn
                )
                VALUES (
                    v_NewUserId, p_OrganizationId, p_Qualification, p_Designation, p_Salary, NOW()
                );
            ELSEIF v_RoleName = 'Parent' THEN
                INSERT INTO Parents (
                    UserId, OrganizationId, Occupation, Address, CreatedOn
                )
                VALUES (
                    v_NewUserId, p_OrganizationId, p_Occupation, p_Address, NOW()
                );
            ELSEIF v_RoleName = 'Student' THEN
                INSERT INTO Students (
                    UserId, OrganizationId, AdmissionNo, AdmissionDate, ParentId,
                    CurrentClassId, CurrentSectionId, StudentType, MotherName, FatherName, CreatedOn
                )
                VALUES (
                    v_NewUserId, p_OrganizationId, p_AdmissionNo, CURDATE(), NULL,
                    p_ClassId, p_SectionId, p_StudentType, p_MotherName, p_FatherName, NOW()
                );
            END IF;

            INSERT INTO UserActivityLogs (
                OrganizationId, UserId, ActionType, EntityName, EntityId, DESCRIPTION, CreatedOn
            )
            VALUES (
                p_OrganizationId,
                p_CreatedBy,
                'CREATE',
                'User',
                v_NewUserId,
                CONCAT('Created new ', v_RoleName, ' user ', p_Username),
                NOW()
            );

            SELECT 1 AS SuccessFlag, CONCAT(v_RoleName, ' user created successfully.') AS Message;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;
