using SchoolMgmt.Shared.Models.Reports;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IFeeReportService
    {
        Task<IEnumerable<DailyCollectionDto>> GetDailyCollectionAsync(int orgId, DateTime from, DateTime to, string? mode);
        Task<IEnumerable<ClassOutstandingDto>> GetClassOutstandingAsync(int orgId, int classId, int termId, int sessionId);
        Task<PaginatedResponse<StudentOutstandingDto>> GetStudentOutstandingAsync(int orgId, int classId, string? search, int page, int size);
        Task<IEnumerable<FeeTypeCollectionDto>> GetFeeTypeCollectionAsync(int orgId, DateTime? from, DateTime? to, int termId, int sessionId);
        Task<IEnumerable<StudentLedgerEntryDto>> GetStudentLedgerAsync(int orgId, int studentId, DateTime? from, DateTime? to);
        Task StreamDailyCollectionCsvAsync(int orgId, DateTime from, DateTime to, string? mode, Stream output, CancellationToken ct = default);
        Task StreamClassOutstandingCsvAsync(int orgId, int classId, int termId, int sessionId, Stream output, CancellationToken ct = default);
        Task StreamStudentOutstandingCsvAsync(int orgId, int classId, string? search, Stream output, CancellationToken ct = default);
        Task StreamFeeTypeCollectionCsvAsync(int orgId, DateTime? from, DateTime? to, int termId, int sessionId, Stream output, CancellationToken ct = default);
        Task StreamStudentLedgerCsvAsync(int orgId, int studentId, DateTime? from, DateTime? to, Stream output, CancellationToken ct = default);
    }
}
