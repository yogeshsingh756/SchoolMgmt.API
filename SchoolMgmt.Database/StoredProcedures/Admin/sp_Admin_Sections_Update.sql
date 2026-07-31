-- Procedure: sp_Admin_Sections_Update
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_Admin_Sections_Update`;

DELIMITER $$

CREATE PROCEDURE `sp_Admin_Sections_Update` (IN `p_SectionId` INT, IN `p_OrganizationId` INT, IN `p_SectionName` VARCHAR(50), IN `p_ClassTeacherId` INT, IN `p_Capacity` INT, IN `p_Description` VARCHAR(255), IN `p_IsActive` TINYINT(1), IN `p_ModifiedBy` INT)   BEGIN
    DECLARE v_SectionExists INT DEFAULT 0;
    DECLARE v_TeacherExists INT DEFAULT 0;

    -- ✅ Check section ownership
    SELECT COUNT(*) INTO v_SectionExists
    FROM Sections
    WHERE SectionId = p_SectionId AND OrganizationId = p_OrganizationId;

    IF v_SectionExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid SectionId or Section does not belong to organization.';
    END IF;

    -- ✅ Validate teacher if assigned
    IF p_ClassTeacherId IS NOT NULL AND p_ClassTeacherId > 0 THEN
        SELECT COUNT(*) INTO v_TeacherExists
        FROM Teachers
        WHERE TeacherId = p_ClassTeacherId AND OrganizationId = p_OrganizationId;

        IF v_TeacherExists = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid TeacherId or Teacher does not belong to organization.';
        END IF;
    END IF;

    UPDATE Sections
    SET 
        SectionName = p_SectionName,
        ClassTeacherId = p_ClassTeacherId,
        Capacity = IFNULL(p_Capacity, 0),
        DESCRIPTION = p_Description,
        IsActive = IFNULL(p_IsActive, 1),
        ModifiedBy = p_ModifiedBy,
        ModifiedOn = NOW()
    WHERE SectionId = p_SectionId AND OrganizationId = p_OrganizationId;

    SELECT 1 AS SuccessFlag, 'Section updated successfully.' AS Message;
END$$

DELIMITER ;