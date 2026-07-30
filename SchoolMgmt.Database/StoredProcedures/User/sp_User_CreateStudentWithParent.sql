-- Procedure: sp_User_CreateStudentWithParent
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_CreateStudentWithParent`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_User_CreateStudentWithParent` (IN `p_OrganizationId` INT, IN `p_CreatedBy` INT, IN `p_StudentFirstName` VARCHAR(100), IN `p_StudentLastName` VARCHAR(100), IN `p_StudentUsername` VARCHAR(50), IN `p_StudentEmail` VARCHAR(100), IN `p_StudentPasswordHash` VARCHAR(255), IN `p_StudentPhoneNumber` VARCHAR(20), IN `p_AdmissionNo` VARCHAR(50), IN `p_StudentAddress` VARCHAR(255), IN `p_ClassId` INT, IN `p_Gender` VARCHAR(100), IN `p_MotherName` VARCHAR(100), IN `p_Category` VARCHAR(100), IN `p_FatherName` VARCHAR(100))   BEGIN
    -- DECLARE v_ParentRoleId INT DEFAULT NULL;
    DECLARE v_StudentRoleId INT DEFAULT NULL;
  -- DECLARE v_ParentRoleName VARCHAR(50);
    DECLARE v_StudentRoleName VARCHAR(50);
   -- DECLARE v_ParentUserId INT;
    DECLARE v_StudentUserId INT;
   --  DECLARE v_ParentRowId INT;
    DECLARE v_Exists INT DEFAULT 0;

    -- improved diagnostics
    DECLARE v_sqlstate CHAR(5);
    DECLARE v_errtext TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate = RETURNED_SQLSTATE,
            v_errtext   = MESSAGE_TEXT;
        ROLLBACK;
        SELECT 0 AS SuccessFlag,
               CONCAT('SQLSTATE=', v_sqlstate, ' ERROR=', v_errtext) AS Message;
    END;


proc_end: BEGIN
    START TRANSACTION;

   -- SET p_ParentEmail      = NULLIF(TRIM(p_ParentEmail), '');
   -- SET p_ParentOccupation = IFNULL(p_ParentOccupation, NULL);
   -- SET p_ParentAddress    = IFNULL(p_ParentAddress, NULL);

    SET p_StudentEmail     = NULLIF(TRIM(p_StudentEmail), '');
    SET p_AdmissionNo      = IFNULL(p_AdmissionNo, NULL);
    SET p_ClassId          = IFNULL(p_ClassId, NULL);
    SET p_StudentAddress   = IFNULL(p_StudentAddress, NULL);
    SET p_Gender = TRIM(p_Gender);
    SET p_Gender = 
    CASE 
    WHEN p_Gender IN ('Male','Female','Other') THEN p_Gender
    ELSE NULL
END;

--  NEW: Category & MotherName
    SET p_Category = NULLIF(TRIM(p_Category), '');
    SET p_MotherName = NULLIF(TRIM(p_MotherName), '');
    SET p_FatherName = NULLIF(TRIM(p_FatherName), '');  --  NEW

    SELECT COUNT(*) INTO v_Exists
    FROM Users
    WHERE Username = p_StudentUsername
      OR (p_StudentEmail IS NOT NULL AND Email = p_StudentEmail);

    IF v_Exists > 0 THEN
        ROLLBACK;
        SELECT 0 AS SuccessFlag, 'Student username or email already exists.' AS Message;
        LEAVE proc_end;
    END IF;

    SELECT RoleId, RoleName INTO v_StudentRoleId, v_StudentRoleName
    FROM Roles
    WHERE RoleName = 'Student'
    LIMIT 1;

    IF v_StudentRoleId IS NULL THEN
        ROLLBACK;
        SELECT 0 AS SuccessFlag, 'Student role not configured.' AS Message;
        LEAVE proc_end;
    END IF;

  --  IF p_ParentId IS NULL THEN
   --     SELECT COUNT(*) INTO v_Exists
    --    FROM Users
     --   WHERE Username = p_ParentUsername
      --    OR (p_ParentEmail IS NOT NULL AND Email = p_ParentEmail);

     --   IF v_Exists > 0 THEN
     --       ROLLBACK;
     --       SELECT 0 AS SuccessFlag, 'Parent username or email already exists.' AS Message;
     --       LEAVE proc_end;
     --   END IF;

     --   SELECT RoleId, RoleName INTO v_ParentRoleId, v_ParentRoleName
     --   FROM Roles
     --   WHERE RoleName = 'Parent'
      --  LIMIT 1;

      --  IF v_ParentRoleId IS NULL THEN
        --    ROLLBACK;
         --   SELECT 0 AS SuccessFlag, 'Parent role not configured.' AS Message;
       --     LEAVE proc_end;
      --  END IF;

       -- INSERT INTO Users (
       --     OrganizationId, RoleId, FirstName, LastName,
      --      Username, Email, PasswordHash, Phone, Gender, Category,
      --      IsActive, CreatedOn, CreatedBy, Address
      --  )
      --  VALUES (
       --     p_OrganizationId, v_ParentRoleId, p_ParentFirstName, p_ParentLastName,
        --    p_ParentUsername, p_ParentEmail, p_ParentPasswordHash, p_ParentPhoneNumber,NULL, NULL,
         --   1, NOW(), p_CreatedBy, p_ParentAddress
      --  );

      --  SET v_ParentUserId = LAST_INSERT_ID();

      --  INSERT INTO UserRoles (UserId, RoleId, CreatedOn)
       -- VALUES (v_ParentUserId, v_ParentRoleId, NOW());

       -- INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
       -- SELECT v_ParentRoleId, p.PermissionId, 0, 0, 0, 0, NOW()
       -- FROM Permissions p
       -- WHERE p.IsActive = 1
       --   AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
       --   AND NOT EXISTS (
         --     SELECT 1 FROM RolePermissions rp
     --         WHERE rp.RoleId = v_ParentRoleId
         --       AND rp.PermissionId = p.PermissionId
     --     );
--
      --  INSERT INTO Parents (
      --      UserId, OrganizationId, Occupation, Address, CreatedOn
      --  )
     --   VALUES (
    --        v_ParentUserId, p_OrganizationId, p_ParentOccupation, p_ParentAddress, NOW()
     --   );

      --  SET v_ParentRowId = LAST_INSERT_ID();
  --  ELSE
   --     SELECT COUNT(*) INTO v_Exists
    --    FROM Parents
    --    WHERE ParentId = p_ParentId
     --     AND OrganizationId = p_OrganizationId;

    --    IF v_Exists = 0 THEN
    --        ROLLBACK;
     --       SELECT 0 AS SuccessFlag, 'Invalid ParentId for this organization.' AS Message;
     --       LEAVE proc_end;
     --   END IF;

     --   SET v_ParentRowId = p_ParentId;
      --  SET v_ParentUserId = NULL;
   -- END IF;

    INSERT INTO Users (
        OrganizationId, RoleId, FirstName, LastName,
        Username, Email, PasswordHash, Phone, Gender, Category,
        IsActive, CreatedOn, CreatedBy, Address
    )
    VALUES (
        p_OrganizationId, v_StudentRoleId, p_StudentFirstName, p_StudentLastName,
        p_StudentUsername, p_StudentEmail, p_StudentPasswordHash, p_StudentPhoneNumber, p_Gender, p_Category,
        1, NOW(), p_CreatedBy, p_StudentAddress
    );

    SET v_StudentUserId = LAST_INSERT_ID();

    INSERT INTO UserRoles (UserId, RoleId, CreatedOn)
    VALUES (v_StudentUserId, v_StudentRoleId, NOW());

    INSERT INTO RolePermissions (RoleId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, CreatedOn)
    SELECT v_StudentRoleId, p.PermissionId, 0, 0, 0, 0, NOW()
    FROM Permissions p
    WHERE p.IsActive = 1
      AND (p.IsDeleted = 0 OR p.IsDeleted IS NULL)
      AND NOT EXISTS (
          SELECT 1 FROM RolePermissions rp
          WHERE rp.RoleId = v_StudentRoleId
            AND rp.PermissionId = p.PermissionId
      );

    INSERT INTO Students (
        UserId, OrganizationId, AdmissionNo, AdmissionDate, ParentId, CurrentClassId, MotherName, FatherName, CreatedOn
    )
    VALUES (
        v_StudentUserId, p_OrganizationId, p_AdmissionNo, CURDATE(), NULL, p_ClassId, p_MotherName, p_FatherName, NOW()
    );

    -- IF v_ParentUserId IS NOT NULL THEN
     --   INSERT INTO UserActivityLogs (
      --      OrganizationId, UserId, ActionType, EntityName, EntityId, DESCRIPTION, CreatedOn
     --   )
      --  VALUES (
        --    p_OrganizationId,
       --     p_CreatedBy,
       --     'CREATE',
       --     'User',
       --     v_ParentUserId,
      --      CONCAT('Created new Parent user ', p_ParentUsername),
       --     NOW()
      --  );
   -- END IF;

    INSERT INTO UserActivityLogs (
        OrganizationId, UserId, ActionType, EntityName, EntityId, DESCRIPTION, CreatedOn
    )
    VALUES (
        p_OrganizationId,
        p_CreatedBy,
        'CREATE',
        'User',
        v_StudentUserId,
        CONCAT('Created new Student user ', p_StudentUsername),
        NOW()
    );

    COMMIT;

    SELECT
        1 AS SuccessFlag,
        'Student created successfully.' AS Message,
        NULL AS ParentId,
        NULL AS NewParentUserId,
        v_StudentUserId  AS StudentUserId;
END proc_end;
END$$

DELIMITER ;