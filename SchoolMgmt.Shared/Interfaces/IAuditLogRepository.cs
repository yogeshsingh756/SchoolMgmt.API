using SchoolMgmt.Shared.Models.Audit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Interfaces
{
    public interface IAuditLogRepository
    {
        Task<IEnumerable<AuditLogDto>> GetAllAsync(int? organizationId, string? searchText);
        Task<int> InsertAsync(AuditLogCreateDto dto);
    }
}
