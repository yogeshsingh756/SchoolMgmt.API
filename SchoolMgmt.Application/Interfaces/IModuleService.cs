using SchoolMgmt.Application.DTOs.Module;
using SchoolMgmt.Shared.Models.Permission;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IModuleService
    {
        Task<IEnumerable<ModuleDto>> GetAllModulesAsync();
        Task<(int ModuleId, bool Success, string Message)> CreateModuleAsync(ModuleDto input, int createdBy);
        Task<(bool Success, string Message)> UpdateModuleAsync(int moduleId, ModuleDto input, int modifiedBy);
        Task<(bool Success, string Message)> DeleteModuleAsync(int moduleId, int modifiedBy);

        Task<IEnumerable<SubModuleDto>> GetSubModulesByModuleAsync(int moduleId);
        Task<(int SubModuleId, bool Success, string Message)> CreateSubModuleAsync(SubModuleDto input, int createdBy);
        Task<(bool Success, string Message)> UpdateSubModuleAsync(int subModuleId, SubModuleDto input, int modifiedBy);
        Task<(bool Success, string Message)> DeleteSubModuleAsync(int subModuleId, int modifiedBy);
    }
}
