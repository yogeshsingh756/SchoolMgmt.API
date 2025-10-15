using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Audit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class AuditLogService : IAuditLogService
    {
        private readonly IAuditLogRepository _repo;

        public AuditLogService(IAuditLogRepository repo)
        {
            _repo = repo;
        }

        public async Task<IEnumerable<AuditLogDto>> GetAllAsync(int? organizationId, string? searchText)
        {
            return await _repo.GetAllAsync(organizationId, searchText);
        }

        public async Task<bool> CreateAsync(AuditLogCreateDto dto)
        {
            var rows = await _repo.InsertAsync(dto);
            return rows > 0;
        }
    }
}
