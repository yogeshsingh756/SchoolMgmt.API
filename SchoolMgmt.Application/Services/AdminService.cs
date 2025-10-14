using Dapper;
using SchoolMgmt.Application.DTOs.Admin;
using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Application.DTOs.User;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class AdminService : IAdminService
    {
        private readonly AdminRepository _repo;
        public AdminService(AdminRepository adminRepository)
        {
            _repo = adminRepository;
        }

        public async Task<(bool Success, string Message)> CreateUserAsync(int organizationId, CreateUserRequest req, int createdBy)
        {
            // Hash password securely
            var hashedPassword = BCrypt.Net.BCrypt.HashPassword(req.Password, workFactor: 11);
            return await _repo.CreateUserAsync(
        organizationId,
        req.RoleName,
        req.FirstName,
        req.LastName,
        req.Username,
        req.Email,
        hashedPassword,
        req.PhoneNumber,
        createdBy,
        req.Qualification,
        req.Designation,
        req.Salary,
        req.Occupation,
        req.Address,
        req.AdmissionNo,
        req.ParentId,
        req.ClassId
    );
        }
        public async Task<AdminDashboardDto> GetDashboardAsync(int organizationId)
        {
            var entity = await _repo.GetDashboardAsync(organizationId);
            return new AdminDashboardDto
            {
                TotalStudents = entity.TotalStudents,
                TotalTeachers = entity.TotalTeachers,
                TotalParents = entity.TotalParents,
                TotalCourses = entity.TotalCourses,
                TotalClasses = entity.TotalClasses
            };
        }

        public async Task<(bool Success, string Message)> UpdateUserAsync(int organizationId, UpdateUserRequest req, int modifiedBy)
        {
            return await _repo.UpdateUserAsync(
        organizationId,
        req.UserId,
        req.FirstName,
        req.LastName,
        req.Email,
        req.Phone,
        modifiedBy,
        req.Qualification,
        req.Designation,
        req.Salary,
        req.Occupation,
        req.Address,
        req.AdmissionNo,
        req.ParentId,
        req.ClassId
    );
        }

        public async Task<(bool Success, string Message)> SoftDeleteUserAsync(int organizationId, int userId, int modifiedBy)
        {
            return await _repo.SoftDeleteUserAsync(organizationId, userId, modifiedBy);
        }
        public async Task<PaginatedUserResponse> GetAllUsersAsync(int organizationId, GetUsersRequest req)
        {
            var (usersDb, total) = await _repo.GetAllUsersAsync(
                organizationId, req.PageNumber, req.PageSize, req.Search, req.StatusFilter);

            var mapped = usersDb.Select(u => new AdminUserDto
            {
                UserId = u.UserId,
                FullName = u.FullName,
                Username = u.Username,
                Email = u.Email,
                Phone = u.Phone,
                RoleName = u.RoleName,
                Status = u.Status,
                CreatedOn = u.CreatedOn,
                LastModified = u.LastModified,
                ModifiedByName = u.ModifiedByName
            });

            return new PaginatedUserResponse
            {
                Users = mapped,
                TotalCount = total,
                PageNumber = req.PageNumber,
                PageSize = req.PageSize
            };
        }

        public async Task<IEnumerable<RoleDto>> GetAssignableRolesForAdminAsync(int adminId)
        {
            var roles = await _repo.GetAssignableRolesForAdminAsync(adminId);
            return roles.Select(r => new RoleDto
            {
                RoleId = r.RoleId,
                RoleName = r.RoleName
            });
        }
    }
}
