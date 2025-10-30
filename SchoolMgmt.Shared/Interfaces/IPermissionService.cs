using SchoolMgmt.Shared.Models.Permission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Interfaces
{
    public interface IPermissionService
    {
        Task<IEnumerable<PermissionDto>> GetAllAsync();
        Task<IEnumerable<RolePermissionDto>> GetByRoleAsync(int roleId);
        Task<bool> UpsertRolePermissionAsync(RolePermissionDto dto);

        // New
        Task<IEnumerable<PermissionDto>> GetEffectivePermissionsAsync(int userId);
        Task<IEnumerable<PermissionDtoV2>> GetEffectivePermissionsV2Async(int userId);
        Task<bool> UpsertUserPermissionsAsync(int userId, IEnumerable<UserPermissionDtoV2> permissions, int modifiedBy);
        Task<bool> UpsertUserPermissionsV2Async(int userId, IEnumerable<UserPermissionDto> permissions, int modifiedBy);
        Task<IEnumerable<UserPermissionDtoV2>> GetUserPermissionsAsync(int userId,int adminId);
        Task<IEnumerable<dynamic>> GetEffectivePermissionsAtLoginAsync(int userId);
    }
}
