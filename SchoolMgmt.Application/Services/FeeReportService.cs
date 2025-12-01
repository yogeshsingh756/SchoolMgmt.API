using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Models.Reports;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class FeeReportService : IFeeReportService
    {
        private readonly FeeReportsRepository _repo;
        public FeeReportService(FeeReportsRepository repo) => _repo = repo;

        public Task<IEnumerable<DailyCollectionDto>> GetDailyCollectionAsync(int orgId, DateTime from, DateTime to, string? mode)
            => _repo.GetDailyCollectionAsync(orgId, from, to, mode);

        public Task<IEnumerable<ClassOutstandingDto>> GetClassOutstandingAsync(int orgId, int classId, int termId, int sessionId)
            => _repo.GetClassOutstandingAsync(orgId, classId, termId, sessionId);

        public Task<PaginatedResponse<StudentOutstandingDto>> GetStudentOutstandingAsync(int orgId, int classId, string? search, int page, int size)
            => _repo.GetStudentOutstandingAsync(orgId, classId, search, page, size);

        public Task<IEnumerable<FeeTypeCollectionDto>> GetFeeTypeCollectionAsync(int orgId, DateTime? from, DateTime? to, int termId, int sessionId)
            => _repo.GetFeeTypeCollectionAsync(orgId, from, to, termId, sessionId);

        public Task<IEnumerable<StudentLedgerEntryDto>> GetStudentLedgerAsync(int orgId, int studentId, DateTime? from, DateTime? to)
            => _repo.GetStudentLedgerAsync(orgId, studentId, from, to);

        public Task StreamDailyCollectionCsvAsync(int orgId, DateTime from, DateTime to, string? mode, Stream output, CancellationToken ct = default)
       => _repo.StreamDailyCollectionCsvAsync(orgId, from, to, mode, output, ct);

        public Task StreamClassOutstandingCsvAsync(int orgId, int classId, int termId, int sessionId, Stream output, CancellationToken ct = default)
            => _repo.StreamClassOutstandingCsvAsync(orgId, classId, termId, sessionId, output, ct);

        public Task StreamStudentOutstandingCsvAsync(int orgId, int classId, string? search, Stream output, CancellationToken ct = default)
            => _repo.StreamStudentOutstandingCsvAsync(orgId, classId, search, output, ct);

        public Task StreamFeeTypeCollectionCsvAsync(int orgId, DateTime? from, DateTime? to, int termId, int sessionId, Stream output, CancellationToken ct = default)
            => _repo.StreamFeeTypeCollectionCsvAsync(orgId, from, to, termId, sessionId, output, ct);

        public Task StreamStudentLedgerCsvAsync(int orgId, int studentId, DateTime? from, DateTime? to, Stream output, CancellationToken ct = default)
            => _repo.StreamStudentLedgerCsvAsync(orgId, studentId, from, to, output, ct);
    }
}
