using Dapper;
using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class RoleService : IRoleService
    {
        private readonly RoleRepository _repo;

        public RoleService(RoleRepository repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Get all roles allowed for an Admin (based on AdminRoleScope)
        /// </summary>
        public async Task<IEnumerable<RoleDto>> GetAssignableRolesByAdminAsync(int adminUserId)
        {
            var roles = await _repo.GetAssignableRolesByAdminAsync(adminUserId);
            return roles.Select(r => new RoleDto
            {
                RoleId = r.RoleId,
                RoleName = r.RoleName
            });
        }

        /// <summary>
        /// Upsert (replace) allowed roles for an Admin into AdminRoleScope
        /// </summary>
        public async Task<bool> UpsertRoleScopeAsync(int adminUserId, List<int> allowedRoleIds, int createdBy)
        {
            var res = await _repo.UpsertRoleScopeAsync(adminUserId, allowedRoleIds, createdBy);
            return res;
        }
        public async Task<IEnumerable<TenantAdminDropdownDto>> GetTenantAdminsAsync()
        {
            var data = await _repo.GetTenantAdminsAsync();
            return data.Select(d => new TenantAdminDropdownDto
            {
                AdminUserId = d.AdminUserId,
                AdminName = d.AdminName,
                OrganizationName = d.OrganizationName,
                RoleName = d.RoleName,
                Email = d.Email,
                Username = d.Username
            });
        }
    }
}
