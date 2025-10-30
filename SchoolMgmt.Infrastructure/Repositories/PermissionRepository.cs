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
        public async Task<IEnumerable<PermissionDtoV2>> GetEffectivePermissionsV2Async(int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryAsync<PermissionDtoV2>(
                "sp_User_GetEffectivePermissions",
                new { p_UserId = userId },
                commandType: CommandType.StoredProcedure);
            return result;
        }

        public async Task<bool> UpsertUserPermissionsAsync(int userId, IEnumerable<UserPermissionDtoV2> permissions, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();

            try
            {
                // ✅ Optional: clear existing permissions that are no longer assigned
                var assignedIds = permissions.Where(p => p.IsAssigned).Select(p => p.PermissionId).ToList();

                // Remove any old user-specific permission records that are NOT in the current list
                // This ensures clean sync between UI state and DB.
                await conn.ExecuteAsync(
                    "DELETE FROM UserPermissions WHERE UserId = @UserId AND PermissionId NOT IN @PermissionIds;",
                    new { UserId = userId, PermissionIds = assignedIds }
                );

                // ✅ Insert/Update permissions
                foreach (var p in permissions.Where(x => x.IsAssigned))
                {
                    await conn.ExecuteAsync(
                        "sp_UserPermissions_Upsert",
                        new
                        {
                            p_UserId = userId,
                            p_PermissionId = p.PermissionId,
                            p_CanView = p.CanView,
                            p_CanCreate = p.CanCreate,
                            p_CanEdit = p.CanEdit,
                            p_CanDelete = p.CanDelete,
                            p_ModifiedBy = modifiedBy
                        },
                        commandType: CommandType.StoredProcedure
                    );
                }
                return true;
            }
            catch (Exception ex)
            {
                // 🔥 Optional: log exception here
                Console.WriteLine("Error in UpsertUserPermissionsAsync: " + ex.Message);
                return false;
            }
        }

        public async Task<IEnumerable<UserPermissionDtoV2>> GetUserPermissionsAsync(int userId,int adminId)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_UserId", userId);
            p.Add("p_AdminId", adminId);

            var list = await conn.QueryAsync<UserPermissionDtoV2>(
                "sp_UserPermissions_GetByUserId",
                p,
                commandType: CommandType.StoredProcedure
            );
            return list.ToList();
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

        public async Task<IEnumerable<dynamic>> GetEffectivePermissionsAtLoginAsync(int userId)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryAsync<dynamic>(
                "sp_User_GetEffectivePermissionsForLogin",
                new { p_UserId = userId },
                commandType: CommandType.StoredProcedure
            );
            return result; 
        }
    }
}
