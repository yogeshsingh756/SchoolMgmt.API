using SchoolMgmt.Application.DTOs.Module;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Permission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class ModuleService : IModuleService
    {
        private readonly ModuleRepository _repo;
        public ModuleService(ModuleRepository repo) => _repo = repo;

        public async Task<IEnumerable<ModuleDto>> GetAllModulesAsync()
        {
            var list = await _repo.GetAllAsync();
            return list.Select(m => new ModuleDto
            {
                ModuleId = m.ModuleId,
                ModuleName = m.ModuleName,
                Description = m.Description,
                Icon = m.Icon,
                RoutePath = m.RoutePath,
                OrderNo = m.OrderNo,
                IsActive = m.IsActive,
                CreatedOn = m.CreatedOn,
                AssignedRoleIds = !string.IsNullOrEmpty(m.AssignedRoleIds)
            ? m.AssignedRoleIds.Split(',')
                .Where(x => int.TryParse(x, out _))
                .Select(int.Parse)
                .ToList()
            : new List<int>()
            });
        }

        public async Task<(int ModuleId, bool Success, string Message)> CreateModuleAsync(ModuleDto input, int createdBy)
        {
            var (id, ok, msg) = await _repo.CreateAsync(input.ModuleName, input.Description, input.Icon, input.RoutePath, input.OrderNo, createdBy, input.AssignedRoleIds);
            return (id, ok, msg);
        }

        public async Task<(bool Success, string Message)> UpdateModuleAsync(int moduleId, ModuleDto input, int modifiedBy)
        {
            return await _repo.UpdateAsync(moduleId, input.ModuleName, input.Description, input.Icon, input.RoutePath, input.OrderNo, input.IsActive, modifiedBy, input.AssignedRoleIds);
        }

        public async Task<(bool Success, string Message)> DeleteModuleAsync(int moduleId, int modifiedBy)
        {
            return await _repo.DeleteAsync(moduleId, modifiedBy);
        }

        public async Task<IEnumerable<SubModuleDto>> GetSubModulesByModuleAsync(int moduleId)
        {
            var list = await _repo.GetSubModulesByModuleAsync(moduleId);
            return list.Select(s => new SubModuleDto
            {
                SubModuleId = s.SubModuleId,
                ModuleId = s.ModuleId,
                SubModuleName = s.SubModuleName,
                Description = s.Description,
                RoutePath = s.RoutePath,
                OrderNo = s.OrderNo,
                IsActive = s.IsActive,
                CreatedOn = s.CreatedOn,
                AssignedRoleIds = !string.IsNullOrEmpty(s.AssignedRoleIds)
            ? s.AssignedRoleIds.Split(',')
                .Where(x => int.TryParse(x, out _))
                .Select(int.Parse)
                .ToList()
            : new List<int>()
            });
        }

        public async Task<(int SubModuleId, bool Success, string Message)> CreateSubModuleAsync(SubModuleDto input, int createdBy)
        {
            return await _repo.CreateSubModuleAsync(input.ModuleId, input.SubModuleName, input.Description, input.RoutePath, input.OrderNo, createdBy,input.AssignedRoleIds);
        }

        public async Task<(bool Success, string Message)> UpdateSubModuleAsync(int subModuleId, SubModuleDto input, int modifiedBy)
        {
            return await _repo.UpdateSubModuleAsync(subModuleId, input.SubModuleName, input.Description, input.RoutePath, input.OrderNo, input.IsActive, modifiedBy, input.AssignedRoleIds);
        }

        public async Task<(bool Success, string Message)> DeleteSubModuleAsync(int subModuleId, int modifiedBy)
        {
            return await _repo.DeleteSubModuleAsync(subModuleId, modifiedBy);
        }
    }
}
