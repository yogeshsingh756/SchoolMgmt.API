-- Procedure: sp_Admin_Classes_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Classes_Update`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Classes_Update` (IN `p_ClassId` INT, IN `p_OrganizationId` INT, IN `p_ClassName` VARCHAR(100), IN `p_Description` VARCHAR(255), IN `p_ClassTeacherId` INT, IN `p_AcademicYear` VARCHAR(20), IN `p_OrderNo` INT, IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    DECLARE v_ClassExists INT DEFAULT 0;
    DECLARE v_TeacherExists INT DEFAULT 0;

    -- ✅ Check if class belongs to organization
    SELECT COUNT(*) INTO v_ClassExists
    FROM Classes
    WHERE ClassId = p_ClassId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;

    IF v_ClassExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid ClassId or Class does not belong to organization.';
    END IF;

    -- ✅ Check teacher’s organization if assigned
    IF p_ClassTeacherId IS NOT NULL AND p_ClassTeacherId > 0 THEN
        SELECT COUNT(*) INTO v_TeacherExists
        FROM Teachers
        WHERE TeacherId = p_ClassTeacherId AND OrganizationId = p_OrganizationId;

        IF v_TeacherExists = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid TeacherId or Teacher does not belong to organization.';
        END IF;
    END IF;

    UPDATE Classes
    SET 
        ClassName = p_ClassName,
        DESCRIPTION = p_Description,
        ClassTeacherId = p_ClassTeacherId,
        AcademicYear = p_AcademicYear,
        OrderNo = IFNULL(p_OrderNo, 0),
        IsActive = IFNULL(p_IsActive, 1),
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE ClassId = p_ClassId AND OrganizationId = p_OrganizationId AND IsDeleted = 0;

    SELECT 1 AS SuccessFlag, 'Class updated successfully.' AS Message;
END$$

DELIMITER ;