using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Models.Permission;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class SuperAdminRoleService : ISuperAdminRoleService
    {
        private readonly SuperAdminRoleRepository _repo;
        public SuperAdminRoleService(SuperAdminRoleRepository repo)
        {
            _repo = repo;
        }

        public async Task<IEnumerable<RoleDto>> GetAllRolesAsync()
        {
            var dbRoles = await _repo.GetAllRolesAsync();
            return dbRoles.Select(r => new RoleDto
            {
                RoleId = r.RoleId,
                RoleName = r.RoleName
            }).ToList();
        }

        public async Task<(bool Success, string Message)> CreateRoleAsync(string roleName, int createdBy) =>
            await _repo.CreateRoleAsync(roleName, createdBy);

        public async Task<(bool Success, string Message)> UpdateRoleAsync(int roleId, string roleName, int modifiedBy) =>
            await _repo.UpdateRoleAsync(roleId, roleName, modifiedBy);

        public async Task<(bool Success, string Message)> SoftDeleteRoleAsync(int roleId, int modifiedBy) =>
            await _repo.SoftDeleteRoleAsync(roleId, modifiedBy);

        public async Task<IEnumerable<DTOs.SuperAdmin.RolePermissionDto>> GetRolePermissionsAsync(int roleId)
        {
            var dbPerms = await _repo.GetRolePermissionsAsync(roleId);
            return dbPerms.Select(p => new DTOs.SuperAdmin.RolePermissionDto
            {
                PermissionId = p.PermissionId,
                PermissionKey = p.PermissionKey,
                PermissionName = p.PermissionName,
                CanView = p.CanView,
                CanCreate = p.CanCreate,
                CanEdit = p.CanEdit,
                CanDelete = p.CanDelete
            }).ToList();
        }

        public async Task<(bool Success, string Message)> AssignPermissionAsync(RolePermissionUpdateDto req, int modifiedBy)
        {
            return await _repo.AssignPermissionAsync(
                req.RoleId, req.PermissionId, req.CanView, req.CanCreate, req.CanEdit, req.CanDelete, modifiedBy);
        }

        public async Task<IEnumerable<Permission>> GetAllPermissionsAsync()
        {
            var result = await _repo.GetAllPermissionsAsync();
            return result;
        }
    }
}
