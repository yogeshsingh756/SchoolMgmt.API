using Dapper;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Audit;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class AuditLogRepository : IAuditLogRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public AuditLogRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<IEnumerable<AuditLogDto>> GetAllAsync(int? organizationId, string? searchText)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_OrganizationId", organizationId);
            p.Add("p_SearchText", searchText);

            return await conn.QueryAsync<AuditLogDto>(
                "sp_AuditLog_GetAll",
                p,
                commandType: CommandType.StoredProcedure);
        }

        public async Task<int> InsertAsync(AuditLogCreateDto dto)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_OrganizationId", dto.OrganizationId);
            p.Add("p_UserId", dto.UserId);
            p.Add("p_EntityName", dto.EntityName);
            p.Add("p_ActionType", dto.ActionType);
            p.Add("p_EntityKey", dto.EntityKey);
            p.Add("p_Description", dto.Description);
            p.Add("p_OldValue", dto.OldValue);
            p.Add("p_NewValue", dto.NewValue);
            p.Add("p_IpAddress", dto.IpAddress);
            p.Add("p_UserAgent", dto.UserAgent);

            return await conn.ExecuteAsync("sp_AuditLog_Insert", p, commandType: CommandType.StoredProcedure);
        }
    }
}
