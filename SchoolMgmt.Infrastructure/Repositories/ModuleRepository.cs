using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using System.Data;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class ModuleRepository
    {
        private readonly IDbConnectionFactory _dbFactory;
        public ModuleRepository(IDbConnectionFactory dbFactory) => _dbFactory = dbFactory;

        public async Task<IEnumerable<Module>> GetAllAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<Module>("sp_Module_GetAll", commandType: CommandType.StoredProcedure);
        }

        public async Task<(int ModuleId, bool Success, string Message)> CreateAsync(string moduleName, string? description, string? icon, string? routePath, int orderNo, int createdBy, List<int> assignedRoleIds)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_ModuleName", moduleName);
            p.Add("p_Description", description);
            p.Add("p_Icon", icon);
            p.Add("p_RoutePath", routePath);
            p.Add("p_OrderNo", orderNo);
            p.Add("p_CreatedBy", createdBy);
            p.Add("p_AssignedRoleIds", string.Join(",", assignedRoleIds));

            var res = await conn.QueryFirstAsync<dynamic>("sp_Module_Create", p, commandType: CommandType.StoredProcedure);
            int id = res.ModuleId != null ? (int)res.ModuleId : 0;
            return (id, res.SuccessFlag == 1, (string)res.Message);
        }

        public async Task<(bool Success, string Message)> UpdateAsync(int moduleId, string moduleName, string? description, string? icon, string? routePath, int orderNo, bool isActive, int modifiedBy, List<int> assignRolsIds)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_ModuleId", moduleId);
            p.Add("p_ModuleName", moduleName);
            p.Add("p_Description", description);
            p.Add("p_Icon", icon);
            p.Add("p_RoutePath", routePath);
            p.Add("p_OrderNo", orderNo);
            p.Add("p_IsActive", isActive ? 1 : 0);
            p.Add("p_ModifiedBy", modifiedBy);
            p.Add("p_AssignedRoleIds", string.Join(",", assignRolsIds));

            var res = await conn.QueryFirstAsync<dynamic>("sp_Module_Update", p, commandType: CommandType.StoredProcedure);
            return (res.SuccessFlag == 1, (string)res.Message);
        }

        public async Task<(bool Success, string Message)> DeleteAsync(int moduleId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_ModuleId", moduleId);
            p.Add("p_ModifiedBy", modifiedBy);
            var res = await conn.QueryFirstAsync<dynamic>("sp_Module_Delete", p, commandType: CommandType.StoredProcedure);
            return (res.SuccessFlag == 1, (string)res.Message);
        }

        public async Task<IEnumerable<SubModule>> GetSubModulesByModuleAsync(int moduleId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<SubModule>("sp_SubModule_GetByModule", new { p_ModuleId = moduleId }, commandType: CommandType.StoredProcedure);
        }

        public async Task<(int SubModuleId, bool Success, string Message)> CreateSubModuleAsync(int moduleId, string subModuleName, string? description, string? routePath, int orderNo, int createdBy, List<int> assignedRoleIds)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_ModuleId", moduleId);
            p.Add("p_SubModuleName", subModuleName);
            p.Add("p_Description", description);
            p.Add("p_RoutePath", routePath);
            p.Add("p_OrderNo", orderNo);
            p.Add("p_CreatedBy", createdBy);
            p.Add("p_AssignedRoleIds", string.Join(",", assignedRoleIds));

            var res = await conn.QueryFirstAsync<dynamic>("sp_SubModule_Create", p, commandType: CommandType.StoredProcedure);
            int id = res.SubModuleId != null ? (int)res.SubModuleId : 0;
            return (id, res.SuccessFlag == 1, (string)res.Message);
        }

        public async Task<(bool Success, string Message)> UpdateSubModuleAsync(int subModuleId, string subModuleName, string? description, string? routePath, int orderNo, bool isActive, int modifiedBy, List<int> assignRoleIds)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_SubModuleId", subModuleId);
            p.Add("p_SubModuleName", subModuleName);
            p.Add("p_Description", description);
            p.Add("p_RoutePath", routePath);
            p.Add("p_OrderNo", orderNo);
            p.Add("p_IsActive", isActive ? 1 : 0);
            p.Add("p_ModifiedBy", modifiedBy);
            p.Add("p_AssignedRoleIds", string.Join(",", assignRoleIds));

            var res = await conn.QueryFirstAsync<dynamic>("sp_SubModule_Update", p, commandType: CommandType.StoredProcedure);
            return (res.SuccessFlag == 1, (string)res.Message);
        }

        public async Task<(bool Success, string Message)> DeleteSubModuleAsync(int subModuleId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_SubModuleId", subModuleId);
            p.Add("p_ModifiedBy", modifiedBy);
            var res = await conn.QueryFirstAsync<dynamic>("sp_SubModule_Delete", p, commandType: CommandType.StoredProcedure);
            return (res.SuccessFlag == 1, (string)res.Message);
        }
    }
}
