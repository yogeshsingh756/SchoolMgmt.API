using SchoolMgmt.Shared.Models.Audit;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IAuditLogService
    {
        Task<IEnumerable<AuditLogDto>> GetAllAsync(int? organizationId, string? searchText);
        Task<bool> CreateAsync(AuditLogCreateDto dto);
    }
}
