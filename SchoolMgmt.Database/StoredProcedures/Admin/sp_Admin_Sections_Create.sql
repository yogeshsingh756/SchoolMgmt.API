-- Procedure: sp_Admin_Sections_Create
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sections_Create`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Sections_Create` (IN `p_OrganizationId` INT, IN `p_ClassId` INT, IN `p_SectionName` VARCHAR(50), IN `p_ClassTeacherId` INT, IN `p_Capacity` INT, IN `p_Description` VARCHAR(255), IN `p_CreatedBy` INT)   BEGIN
    DECLARE v_ClassExists INT DEFAULT 0;
    DECLARE v_TeacherExists INT DEFAULT 0;

    -- ✅ Check if class exists for this organization
    SELECT COUNT(*) INTO v_ClassExists
    FROM Classes
    WHERE ClassId = p_ClassId AND OrganizationId = p_OrganizationId;

    IF v_ClassExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid ClassId or Class does not belong to organization.';
    END IF;

    -- ✅ If teacher assigned, validate that the teacher belongs to same organization
    IF p_ClassTeacherId IS NOT NULL AND p_ClassTeacherId > 0 THEN
        SELECT COUNT(*) INTO v_TeacherExists
        FROM Teachers
        WHERE TeacherId = p_ClassTeacherId AND OrganizationId = p_OrganizationId;

        IF v_TeacherExists = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid TeacherId or Teacher does not belong to organization.';
        END IF;
    END IF;

    -- ✅ Insert into Sections table
    INSERT INTO Sections 
        (OrganizationId, ClassId, SectionName, ClassTeacherId, Capacity, Description, IsActive, CreatedOn, CreatedBy)
    VALUES 
        (p_OrganizationId, p_ClassId, p_SectionName, p_ClassTeacherId, IFNULL(p_Capacity, 0), p_Description, 1, NOW(), p_CreatedBy);

    SELECT LAST_INSERT_ID() AS SectionId, 'Section created successfully.' AS Message;
END$$

DELIMITER ;