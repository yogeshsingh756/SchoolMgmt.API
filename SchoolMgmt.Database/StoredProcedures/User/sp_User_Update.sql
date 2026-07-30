-- Procedure: sp_User_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_Update`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_User_Update` (IN `p_OrganizationId` INT, IN `p_UserId` INT, IN `p_FirstName` VARCHAR(100), IN `p_LastName` VARCHAR(100), IN `p_Email` VARCHAR(100), IN `p_Phone` VARCHAR(20), IN `p_ModifiedBy` INT, IN `p_Qualification` VARCHAR(150), IN `p_Designation` VARCHAR(100), IN `p_Salary` DECIMAL(10,2), IN `p_Occupation` VARCHAR(100), IN `p_Address` VARCHAR(255), IN `p_AdmissionNo` VARCHAR(50), IN `p_ClassId` INT, IN `p_Gender` VARCHAR(100), IN `p_MotherName` VARCHAR(100), IN `p_Category` VARCHAR(100), IN `p_FatherName` VARCHAR(100))   proc_label: BEGIN
    -- declarations must come first in MariaDB stored blocks
    DECLARE v_Exists INT DEFAULT 0;
    DECLARE v_RoleName VARCHAR(50);
    DECLARE v_EmailExists INT DEFAULT 0;
    DECLARE v_CurrentEmail VARCHAR(100);

    -- Ensure all optional parameters are safely nullable
    SET p_Qualification = NULLIF(p_Qualification, '');
    SET p_Designation   = NULLIF(p_Designation, '');
    SET p_Salary        = IFNULL(p_Salary, NULL);
    SET p_Occupation    = NULLIF(p_Occupation, '');
    SET p_Address       = NULLIF(p_Address, '');
    SET p_AdmissionNo   = NULLIF(p_AdmissionNo, '');
    SET p_ClassId       = IFNULL(p_ClassId, NULL);

    -- treat empty email as NULL (i.e. optional)
    SET p_Email = NULLIF(p_Email, '');
    
    SET p_Gender = TRIM(p_Gender);
    SET p_Gender = 
    CASE 
    WHEN p_Gender IN ('Male','Female','Other') THEN p_Gender
    ELSE NULL
END;

--  NEW: Category & MotherName handling
SET p_Category = NULLIF(TRIM(p_Category), '');
SET p_MotherName = NULLIF(TRIM(p_MotherName), '');
SET p_FatherName = NULLIF(TRIM(p_FatherName), '');  --  NEW

    -- Validate user existence
    SELECT COUNT(*) INTO v_Exists
    FROM Users
    WHERE UserId = p_UserId AND OrganizationId = p_OrganizationId AND IFNULL(IsDeleted,0) = 0;

    IF v_Exists = 0 THEN
        SELECT 0 AS SuccessFlag, 'User not found or invalid organization context.' AS Message;
        LEAVE proc_label;
    END IF;

    -- Identify role and fetch current email for logging
    SELECT r.RoleName, u.Email INTO v_RoleName, v_CurrentEmail
    FROM Users u
    INNER JOIN Roles r ON u.RoleId = r.RoleId
    WHERE u.UserId = p_UserId;

    -- if an email is provided, ensure it's unique among other users
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

    -- Update Users table (only overwrite Email when p_Email provided)
    UPDATE Users
    SET 
        FirstName  = p_FirstName,
        LastName   = p_LastName,
        Email      = COALESCE(p_Email, Email),
        Phone      = p_Phone,
        Gender     = COALESCE(p_Gender, Gender),     --  ADDED
        Category   = COALESCE(p_Category, Category), --  ADDED
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW(),
        Address    = p_Address
    WHERE UserId = p_UserId;

    -- Role-specific updates
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
            AdmissionNo    = COALESCE(p_AdmissionNo, AdmissionNo),
            CurrentClassId = COALESCE(p_ClassId, CurrentClassId),
            MotherName     = COALESCE(p_MotherName, MotherName), 
            FatherName     = COALESCE(p_FatherName, FatherName),
            ModifiedBy     = p_ModifiedBy,
            ModifiedOn     = NOW()
        WHERE UserId = p_UserId;
    END IF;

    -- Determine effective email after update for the log
    SET v_CurrentEmail = COALESCE(p_Email, v_CurrentEmail);

    -- Activity log
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

END proc_label$$

DELIMITER ;