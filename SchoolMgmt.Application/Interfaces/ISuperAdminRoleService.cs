using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Models.Permission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface ISuperAdminRoleService
    {
        Task<IEnumerable<RoleDto>> GetAllRolesAsync();
        Task<(bool Success, string Message)> CreateRoleAsync(string roleName, int createdBy);
        Task<(bool Success, string Message)> UpdateRoleAsync(int roleId, string roleName, int modifiedBy);
        Task<(bool Success, string Message)> SoftDeleteRoleAsync(int roleId, int modifiedBy);
        Task<IEnumerable<DTOs.SuperAdmin.RolePermissionDto>> GetRolePermissionsAsync(int roleId);
        Task<(bool Success, string Message)> AssignPermissionsBulkAsync(List<Shared.Models.Permission.RolePermissionUpdateDto> permissions, int modifiedBy);
        Task<IEnumerable<Permission>> GetAllPermissionsAsync();
    }
}
