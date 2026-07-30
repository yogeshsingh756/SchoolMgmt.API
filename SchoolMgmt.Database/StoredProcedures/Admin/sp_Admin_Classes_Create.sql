-- Procedure: sp_Admin_Classes_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Classes_Create`;

DELIMITER $$

CREATE DEFINER=`erp`@`%` PROCEDURE `sp_Admin_Classes_Create` (IN `p_OrganizationId` INT, IN `p_ClassName` VARCHAR(100), IN `p_Description` VARCHAR(255), IN `p_ClassTeacherId` INT, IN `p_AcademicYear` VARCHAR(20), IN `p_OrderNo` INT, IN `p_CreatedBy` INT)   BEGIN
    DECLARE v_TeacherExists INT DEFAULT 0;

    -- ✅ Validation: ensure teacher belongs to same organization
    IF p_ClassTeacherId IS NOT NULL AND p_ClassTeacherId > 0 THEN
        SELECT COUNT(*) INTO v_TeacherExists
        FROM Teachers
        WHERE TeacherId = p_ClassTeacherId AND OrganizationId = p_OrganizationId;

        IF v_TeacherExists = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid TeacherId or Teacher does not belong to organization.';
        END IF;
    END IF;

    INSERT INTO Classes 
        (OrganizationId, ClassName, DESCRIPTION, ClassTeacherId, AcademicYear, OrderNo, IsDeleted, IsActive, CreatedBy, CreatedOn)
    VALUES 
        (p_OrganizationId, p_ClassName, p_Description, p_ClassTeacherId, p_AcademicYear, IFNULL(p_OrderNo, 0), 0, 1, p_CreatedBy, NOW());

    SELECT LAST_INSERT_ID() AS ClassId, 'Class created successfully.' AS Message;
END$$

DELIMITER ;