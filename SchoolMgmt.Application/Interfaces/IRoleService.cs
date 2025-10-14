using SchoolMgmt.Application.DTOs.SuperAdmin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IRoleService
    {
        /// <summary>
        /// Gets the list of roles assignable for a given admin (based on AdminRoleScope).
        /// </summary>
        Task<IEnumerable<RoleDto>> GetAssignableRolesByAdminAsync(int adminUserId);

        /// <summary>
        /// Updates the allowed roles for an admin (Upsert AdminRoleScope).
        /// </summary>
        Task<bool> UpsertRoleScopeAsync(int adminUserId, List<int> allowedRoleIds, int createdBy);
    }
}
