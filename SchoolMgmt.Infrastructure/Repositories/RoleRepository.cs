using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class RoleRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public RoleRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        /// <summary>
        /// Get all roles allowed for an Admin (based on AdminRoleScope)
        /// </summary>
        public async Task<IEnumerable<DbRole>> GetAssignableRolesByAdminAsync(int adminUserId)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_AdminId", adminUserId);

            return await conn.QueryAsync<DbRole>(
                "sp_Roles_GetAssignableByAdmin",
                p,
                commandType: CommandType.StoredProcedure
            );
        }

        /// <summary>
        /// Upsert (replace) allowed roles for an Admin into AdminRoleScope
        /// </summary>
        public async Task<bool> UpsertRoleScopeAsync(int adminUserId, List<int> allowedRoleIds, int createdBy)
        {
            using var conn = _dbFactory.CreateConnection();

            // Convert list to comma-separated values
            var allowedIds = string.Join(",", allowedRoleIds);

            var p = new DynamicParameters();
            p.Add("p_AdminUserId", adminUserId);
            p.Add("p_AllowedRoleIds", allowedIds);
            p.Add("p_CreatedBy", createdBy);

            await conn.ExecuteAsync("sp_AdminRoleScope_Upsert", p, commandType: CommandType.StoredProcedure);
            return true;
        }
        public async Task<IEnumerable<TenantAdminDropdownEntity>> GetTenantAdminsAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<TenantAdminDropdownEntity>(
                "sp_GetAllTenantAdmins",
                commandType: CommandType.StoredProcedure
            );
        }
    }
}
