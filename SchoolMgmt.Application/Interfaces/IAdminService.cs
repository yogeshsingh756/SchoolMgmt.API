using SchoolMgmt.Application.DTOs.Admin;
using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Application.DTOs.User;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IAdminService
    {
        Task<(bool Success, string Message)> CreateUserAsync(int organizationId, CreateUserRequest req, int createdBy);
        Task<AdminDashboardDto> GetDashboardAsync(int organizationId);
        Task<PaginatedUserResponse> GetAllUsersAsync(int organizationId, GetUsersRequest req);
        Task<(bool Success, string Message)> UpdateUserAsync(int organizationId, UpdateUserRequest req, int modifiedBy);
        Task<(bool Success, string Message)> SoftDeleteUserAsync(int organizationId, int userId, int modifiedBy);
        Task<IEnumerable<RoleDto>> GetAssignableRolesForAdminAsync(int adminId);
        Task<PaginatedResponse<ParentDto>> GetParentsAsync(ParentSearchRequest request, int organizationId);
    }
}
