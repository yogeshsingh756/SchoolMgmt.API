-- Procedure: sp_User_SoftDelete
-- Extracted from phpMyAdmin routines dump (erp)

DROP PROCEDURE IF EXISTS `sp_User_SoftDelete`;

DELIMITER $$

CREATE PROCEDURE `sp_User_SoftDelete` (IN `p_OrganizationId` INT, IN `p_UserId` INT, IN `p_ModifiedBy` INT)   BEGIN
    DECLARE v_Exists INT DEFAULT 0;
    DECLARE v_RoleName VARCHAR(50);

    -- ✅ Check if user exists and not deleted
    SELECT COUNT(*) INTO v_Exists
    FROM Users
    WHERE UserId = p_UserId 
      AND OrganizationId = p_OrganizationId 
      AND IsDeleted = 0;

    IF v_Exists = 0 THEN
        SELECT 0 AS SuccessFlag, 'User not found or already deleted.' AS Message;

    ELSE
        -- ✅ Identify role name
        SELECT r.RoleName INTO v_RoleName
        FROM Users u
        INNER JOIN Roles r ON u.RoleId = r.RoleId
        WHERE u.UserId = p_UserId;

        -- ✅ Protect system roles
        IF v_RoleName IN ('SuperAdmin', 'Admin') THEN
            SELECT 0 AS SuccessFlag, 'You cannot delete Admin or SuperAdmin user.' AS Message;

        ELSE
            -- ????️ Soft delete from Users table
            UPDATE Users
            SET 
                IsDeleted  = 1,
                IsActive   = 0,
                ModifiedOn = NOW(),
                ModifiedBy = p_ModifiedBy
            WHERE UserId = p_UserId;

            -- ???? Role-specific cleanup (soft delete if record exists)
            IF v_RoleName = 'Teacher' THEN
                UPDATE Teachers
                SET 
                    IsDeleted  = 1,
                    IsActive   = 0,
                    ModifiedOn = NOW(),
                    ModifiedBy = p_ModifiedBy
                WHERE UserId = p_UserId;

            ELSEIF v_RoleName = 'Parent' THEN
                UPDATE Parents
                SET 
                    IsDeleted  = 1,
                    ModifiedOn = NOW(),
                    ModifiedBy = p_ModifiedBy
                WHERE UserId = p_UserId;

            ELSEIF v_RoleName = 'Student' THEN
                UPDATE Students
                SET 
                    IsDeleted  = 1,
                    ModifiedOn = NOW(),
                    ModifiedBy = p_ModifiedBy
                WHERE UserId = p_UserId;
            END IF;

            -- ???? Log activity
            INSERT INTO UserActivityLogs (
                OrganizationId, UserId, ActionType, EntityName, EntityId, Description, CreatedOn
            )
            VALUES (
                p_OrganizationId,
                p_ModifiedBy,
                'DELETE',
                'User',
                p_UserId,
                CONCAT('Soft-deleted ', v_RoleName, ' user (ID: ', p_UserId, ')'),
                NOW()
            );

            SELECT 1 AS SuccessFlag, CONCAT(v_RoleName, ' user soft deleted successfully.') AS Message;
        END IF;
    END IF;
END$$

DELIMITER ;