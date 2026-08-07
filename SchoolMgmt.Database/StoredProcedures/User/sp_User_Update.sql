-- Procedure: sp_User_Update

DROP PROCEDURE IF EXISTS `sp_User_Update`;

DELIMITER $$

CREATE PROCEDURE `sp_User_Update` (
  IN `p_OrganizationId` INT,
  IN `p_UserId` INT,
  IN `p_FirstName` VARCHAR(100),
  IN `p_LastName` VARCHAR(100),
  IN `p_Email` VARCHAR(100),
  IN `p_Phone` VARCHAR(20),
  IN `p_ModifiedBy` INT,
  IN `p_Qualification` VARCHAR(150),
  IN `p_Designation` VARCHAR(100),
  IN `p_Salary` DECIMAL(10,2),
  IN `p_Occupation` VARCHAR(100),
  IN `p_Address` VARCHAR(255),
  IN `p_AdmissionNo` VARCHAR(50),
  IN `p_ClassId` INT,
  IN `p_Gender` VARCHAR(100),
  IN `p_MotherName` VARCHAR(100),
  IN `p_Category` VARCHAR(100),
  IN `p_FatherName` VARCHAR(100),
  IN `p_SectionId` INT,
  IN `p_StudentType` VARCHAR(20)
)
proc_label: BEGIN
    DECLARE v_Exists INT DEFAULT 0;
    DECLARE v_RoleName VARCHAR(50);
    DECLARE v_EmailExists INT DEFAULT 0;
    DECLARE v_CurrentEmail VARCHAR(100);
    DECLARE v_SectionOk INT DEFAULT 1;

    SET p_Qualification = NULLIF(p_Qualification, '');
    SET p_Designation   = NULLIF(p_Designation, '');
    SET p_Salary        = IFNULL(p_Salary, NULL);
    SET p_Occupation    = NULLIF(p_Occupation, '');
    SET p_Address       = NULLIF(p_Address, '');
    SET p_AdmissionNo   = NULLIF(p_AdmissionNo, '');
    SET p_ClassId       = NULLIF(p_ClassId, 0);
    SET p_SectionId     = NULLIF(p_SectionId, 0);
    SET p_LastName      = NULLIF(TRIM(IFNULL(p_LastName, '')), '');
    SET p_Email = NULLIF(p_Email, '');

    SET p_Gender = TRIM(IFNULL(p_Gender, ''));
    SET p_Gender =
    CASE
    WHEN p_Gender IN ('Male','Female','Other') THEN p_Gender
    ELSE NULL
    END;

    SET p_Category = NULLIF(TRIM(IFNULL(p_Category, '')), '');
    SET p_MotherName = NULLIF(TRIM(IFNULL(p_MotherName, '')), '');
    SET p_FatherName = NULLIF(TRIM(IFNULL(p_FatherName, '')), '');
    SET p_StudentType = TRIM(IFNULL(p_StudentType, ''));
    SET p_StudentType =
    CASE
      WHEN p_StudentType IN ('Regular', 'Private') THEN p_StudentType
      ELSE NULL
    END;

    SELECT COUNT(*) INTO v_Exists
    FROM Users
    WHERE UserId = p_UserId AND OrganizationId = p_OrganizationId AND IFNULL(IsDeleted,0) = 0;

    IF v_Exists = 0 THEN
        SELECT 0 AS SuccessFlag, 'User not found or invalid organization context.' AS Message;
        LEAVE proc_label;
    END IF;

    SELECT r.RoleName, u.Email INTO v_RoleName, v_CurrentEmail
    FROM Users u
    INNER JOIN Roles r ON u.RoleId = r.RoleId
    WHERE u.UserId = p_UserId;

    IF p_Email IS NOT NULL THEN
        SELECT COUNT(*) INTO v_EmailExists
        FROM Users
        WHERE Email = p_Email
          AND UserId <> p_UserId;

        IF v_EmailExists > 0 THEN
            SELECT 0 AS SuccessFlag, 'Email already in use by another user.' AS Message;
            LEAVE proc_label;
        END IF;
    END IF;

    IF v_RoleName IN ('SuperAdmin', 'Admin') THEN
        SELECT 0 AS SuccessFlag, 'You cannot update Admin or SuperAdmin user.' AS Message;
        LEAVE proc_label;
    END IF;

    IF v_RoleName = 'Student' AND p_SectionId IS NOT NULL AND p_ClassId IS NOT NULL THEN
        SELECT COUNT(*) INTO v_SectionOk
        FROM Sections
        WHERE SectionId = p_SectionId
          AND OrganizationId = p_OrganizationId
          AND ClassId = p_ClassId
          AND IFNULL(IsActive, 1) = 1;
        IF v_SectionOk = 0 THEN
            SELECT 0 AS SuccessFlag, 'Invalid section for the selected class.' AS Message;
            LEAVE proc_label;
        END IF;
    END IF;

    UPDATE Users
    SET
        FirstName  = p_FirstName,
        LastName   = p_LastName,
        Email      = COALESCE(p_Email, Email),
        Phone      = p_Phone,
        Gender     = COALESCE(p_Gender, Gender),
        Category   = COALESCE(p_Category, Category),
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW(),
        Address    = p_Address
    WHERE UserId = p_UserId;

    IF v_RoleName = 'Teacher' THEN
        UPDATE Teachers
        SET
            Qualification = COALESCE(p_Qualification, Qualification),
            Designation   = COALESCE(p_Designation, Designation),
            Salary        = COALESCE(p_Salary, Salary),
            ModifiedBy    = p_ModifiedBy,
            ModifiedOn    = NOW()
        WHERE UserId = p_UserId;

    ELSEIF v_RoleName = 'Parent' THEN
        UPDATE Parents
        SET
            Occupation = COALESCE(p_Occupation, Occupation),
            Address    = COALESCE(p_Address, Address),
            ModifiedBy = p_ModifiedBy,
            ModifiedOn = NOW()
        WHERE UserId = p_UserId;

    ELSEIF v_RoleName = 'Student' THEN
        UPDATE Students
        SET
            AdmissionNo      = COALESCE(p_AdmissionNo, AdmissionNo),
            CurrentClassId   = COALESCE(p_ClassId, CurrentClassId),
            CurrentSectionId = CASE
                                 WHEN p_ClassId IS NOT NULL THEN p_SectionId
                                 ELSE CurrentSectionId
                               END,
            StudentType      = COALESCE(p_StudentType, StudentType),
            MotherName       = COALESCE(p_MotherName, MotherName),
            FatherName       = COALESCE(p_FatherName, FatherName),
            ModifiedBy       = p_ModifiedBy,
            ModifiedOn       = NOW()
        WHERE UserId = p_UserId;
    END IF;

    SET v_CurrentEmail = COALESCE(p_Email, v_CurrentEmail);

    INSERT INTO UserActivityLogs (
        OrganizationId, UserId, ActionType, EntityName, EntityId, DESCRIPTION, CreatedOn
    )
    VALUES (
        p_OrganizationId,
        p_ModifiedBy,
        'UPDATE',
        'User',
        p_UserId,
        CONCAT('Updated ', v_RoleName, ' user profile (', IFNULL(v_CurrentEmail,''), ')'),
        NOW()
    );

    SELECT 1 AS SuccessFlag, CONCAT(v_RoleName, ' user updated successfully.') AS Message;

END$$

DELIMITER ;
