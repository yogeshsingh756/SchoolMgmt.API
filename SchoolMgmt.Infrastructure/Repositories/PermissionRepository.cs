using Dapper;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Permission;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class PermissionRepository : IPermissionService
    {
        private readonly IDbConnectionFactory _dbFactory;

        public PermissionRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<IEnumerable<PermissionDto>> GetAllAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<PermissionDto>(
                "sp_Permissions_GetAll",
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<RolePermissionDto>> GetByRoleAsync(int roleId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<RolePermissionDto>(
                "sp_RolePermissions_GetByRoleId",
                new { p_RoleId = roleId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<bool> UpsertRolePermissionAsync(RolePermissionDto dto)
        {
            using var conn = _dbFactory.CreateConnection();
            var affected = await conn.ExecuteAsync(
                "sp_RolePermissions_Upsert",
                new
                {
                    p_RoleId = dto.RoleId,
                    p_PermissionId = dto.PermissionId,
                    p_CanView = dto.CanView ? 1 : 0,
                    p_CanCreate = dto.CanCreate ? 1 : 0,
                    p_CanEdit = dto.CanEdit ? 1 : 0,
                    p_CanDelete = dto.CanDelete ? 1 : 0
                },
                commandType: CommandType.StoredProcedure);

            return affected > 0;
        }

        public async Task<IEnumerable<PermissionDto>> GetEffectivePermissionsAsync(int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryAsync<PermissionDto>(
                "sp_User_GetEffectivePermissions",
                new { p_UserId = userId },
                commandType: CommandType.StoredProcedure);
            return result;
        }

        public async Task<bool> UpsertUserPermissionsAsync(int userId, IEnumerable<UserPermissionDto> permissions, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();

            foreach (var p in permissions)
            {
                await conn.ExecuteAsync(
                    @"INSERT INTO UserPermissions 
              (UserId, PermissionId, CanView, CanCreate, CanEdit, CanDelete, ModifiedBy)
              VALUES (@UserId, @PermissionId, @CanView, @CanCreate, @CanEdit, @CanDelete, @ModifiedBy)
              ON DUPLICATE KEY UPDATE 
                CanView = VALUES(CanView),
                CanCreate = VALUES(CanCreate),
                CanEdit = VALUES(CanEdit),
                CanDelete = VALUES(CanDelete),
                ModifiedOn = NOW(),
                ModifiedBy = @ModifiedBy;",
                    new
                    {
                        UserId = userId,
                        p.PermissionId,
                        p.CanView,
                        p.CanCreate,
                        p.CanEdit,
                        p.CanDelete,
                        ModifiedBy = modifiedBy
                    });
            }

            return true;
        }

        public async Task<IEnumerable<UserPermissionDto>> GetUserPermissionsAsync(int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryAsync<UserPermissionDto>(
                "sp_UserPermissions_GetByUserId",
                new { p_UserId = userId },
                commandType: CommandType.StoredProcedure);
            return result;
        }

        public async Task<bool> UpsertUserPermissionsV2Async(int userId, IEnumerable<UserPermissionDto> permissions, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();

            foreach (var p in permissions)
            {
                await conn.ExecuteAsync(
                    "sp_UserPermissions_Upsert",
                    new
                    {
                        p_UserId = userId,
                        p.PermissionId,
                        p.CanView,
                        p.CanCreate,
                        p.CanEdit,
                        p.CanDelete,
                        p_ModifiedBy = modifiedBy
                    },
                    commandType: CommandType.StoredProcedure);
            }

            return true;
        }

        public async Task<IEnumerable<EffectivePermissionDto>> GetEffectivePermissionsAtLoginAsync(int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_UserId", userId);

            var result = await conn.QueryAsync<EffectivePermissionDto>(
                "sp_User_GetEffectivePermissions",
                p,
                commandType: CommandType.StoredProcedure
            );

            return result;
        }
    }
}
