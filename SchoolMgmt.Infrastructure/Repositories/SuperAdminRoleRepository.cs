using Dapper;
using Microsoft.EntityFrameworkCore;
using SchoolMgmt.Domain.Entities;
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
    public class SuperAdminRoleRepository
    {
        private readonly IDbConnectionFactory _dbFactory;
        public SuperAdminRoleRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<IEnumerable<DbRole>> GetAllRolesAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<DbRole>("sp_Role_GetAll", commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool, string)> CreateRoleAsync(string roleName, int createdBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_RoleName", roleName);
            p.Add("p_CreatedBy", createdBy);
            var result = await conn.QueryFirstAsync<dynamic>("sp_Role_Create", p, commandType: CommandType.StoredProcedure);
            return ((int)result.SuccessFlag == 1, (string)result.Message);
        }

        public async Task<(bool, string)> UpdateRoleAsync(int roleId, string roleName, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_RoleId", roleId);
            p.Add("p_RoleName", roleName);
            p.Add("p_ModifiedBy", modifiedBy);
            var result = await conn.QueryFirstAsync<dynamic>("sp_Role_Update", p, commandType: CommandType.StoredProcedure);
            return ((int)result.SuccessFlag == 1, (string)result.Message);
        }

        public async Task<(bool, string)> SoftDeleteRoleAsync(int roleId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_RoleId", roleId);
            p.Add("p_ModifiedBy", modifiedBy);
            var result = await conn.QueryFirstAsync<dynamic>("sp_Role_SoftDelete", p, commandType: CommandType.StoredProcedure);
            return ((int)result.SuccessFlag == 1, (string)result.Message);
        }

        public async Task<IEnumerable<DbRolePermission>> GetRolePermissionsAsync(int roleId)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_RoleId", roleId);
            return await conn.QueryAsync<DbRolePermission>("sp_Role_GetPermissions", p, commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool Success, string Message)> AssignPermissionsBulkAsync(List<RolePermissionUpdateDto> permissions, int modifiedBy)
        {
            // Open single DB connection for efficiency
            using var conn = _dbFactory.CreateConnection();

            try
            {
                foreach (var item in permissions)
                {
                    var p = new DynamicParameters();
                    p.Add("p_RoleId", item.RoleId);
                    p.Add("p_PermissionId", item.PermissionId);
                    p.Add("p_CanView", item.CanView);
                    p.Add("p_CanCreate", item.CanCreate);
                    p.Add("p_CanEdit", item.CanEdit);
                    p.Add("p_CanDelete", item.CanDelete);
                    p.Add("p_ModifiedBy", modifiedBy);

                    await conn.ExecuteAsync("sp_Role_AssignPermission", p, commandType: CommandType.StoredProcedure);
                }

                return (true, "Permissions assigned successfully.");
            }
            catch (Exception ex)
            {
                return (false, $"Failed to assign permissions: {ex.Message}");
            }
        }

        public async Task<IEnumerable<Permission>> GetAllPermissionsAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<Permission>("sp_Permissions_GetAll", commandType: CommandType.StoredProcedure);
            
        }
    }
}

