using Dapper;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Reports;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class FeeReportsRepository
    {
        private readonly IDbConnectionFactory _dbFactory;
        public FeeReportsRepository(IDbConnectionFactory dbFactory) => _dbFactory = dbFactory;

        public async Task<IEnumerable<DailyCollectionDto>> GetDailyCollectionAsync(int orgId, DateTime from, DateTime to, string? mode)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<DailyCollectionDto>(
                "sp_Report_DailyCollection",
                new { p_OrganizationId = orgId, p_FromDate = from.Date, p_ToDate = to.Date, p_PaymentMode = mode },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<ClassOutstandingDto>> GetClassOutstandingAsync(int orgId, int classId, int termId, int sessionId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<ClassOutstandingDto>(
                "sp_Report_ClassWiseOutstanding",
                new { p_OrganizationId = orgId, p_ClassId = classId, p_TermId = termId, p_SessionId = sessionId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<PaginatedResponse<StudentOutstandingDto>> GetStudentOutstandingAsync(int orgId, int classId, string? search, int page, int size)
        {
            using var conn = _dbFactory.CreateConnection();
            using var multi = await conn.QueryMultipleAsync(
                "sp_Report_StudentOutstanding",
                new { p_OrganizationId = orgId, p_ClassId = classId, p_Search = search, p_PageNumber = page, p_PageSize = size },
                commandType: CommandType.StoredProcedure);

            var items = (await multi.ReadAsync<StudentOutstandingDto>()).ToList();
            var total = (await multi.ReadFirstOrDefaultAsync<int?>()) ?? items.Count;
            return new PaginatedResponse<StudentOutstandingDto> { Data = items, TotalCount = total };
        }

        public async Task<IEnumerable<FeeTypeCollectionDto>> GetFeeTypeCollectionAsync(int orgId, DateTime? from, DateTime? to, int termId, int sessionId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<FeeTypeCollectionDto>(
                "sp_Report_FeeTypeCollection",
                new { p_OrganizationId = orgId, p_FromDate = from, p_ToDate = to, p_TermId = termId, p_SessionId = sessionId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<StudentLedgerEntryDto>> GetStudentLedgerAsync(int orgId, int studentId, DateTime? from, DateTime? to)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<StudentLedgerEntryDto>(
                "sp_Report_StudentLedger",
                new { p_OrganizationId = orgId, p_StudentId = studentId, p_FromDate = from, p_ToDate = to },
                commandType: CommandType.StoredProcedure);
        }

        private static string EscapeCsv(string? s)
        {
            if (string.IsNullOrEmpty(s)) return "";
            var needsQuote = s.Contains(",") || s.Contains("\"") || s.Contains("\n") || s.Contains("\r");
            var outS = s.Replace("\"", "\"\"");
            return needsQuote ? $"\"{outS}\"" : outS;
        }

        // Generic streaming helper that executes a stored-procedure and writes CSV using reader columns
        private async Task StreamFromReaderAsync(
     string spName,
     object? parameters,
     Stream outputStream,
     string[]? columnOrder = null,
     CancellationToken ct = default,
     int? commandTimeoutSeconds = 180)
        {
            using var rawConn = _dbFactory.CreateConnection();

            if (rawConn is not DbConnection conn)
                throw new InvalidOperationException("The provided IDbConnectionFactory returned a non-DbConnection implementation which is not supported for async streaming.");

            await conn.OpenAsync(ct).ConfigureAwait(false);

            using var cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = spName;
            if (commandTimeoutSeconds.HasValue)
                cmd.CommandTimeout = commandTimeoutSeconds.Value;

            if (parameters != null)
            {
                foreach (var prop in parameters.GetType().GetProperties())
                {
                    var val = prop.GetValue(parameters);
                    var dbParam = cmd.CreateParameter();
                    dbParam.ParameterName = "p_" + prop.Name; // match your SP param naming
                    dbParam.Value = val ?? DBNull.Value;
                    dbParam.Direction = ParameterDirection.Input;
                    cmd.Parameters.Add(dbParam);
                }
            }

            // execute reader with SequentialAccess for large payloads
            using var reader = await ((DbCommand)cmd).ExecuteReaderAsync(CommandBehavior.SequentialAccess, ct).ConfigureAwait(false);

            // Create StreamWriter WITHOUT using statement (we will DisposeAsync at the end)
            var writer = new StreamWriter(outputStream, new UTF8Encoding(false), 8192, leaveOpen: true);

            try
            {
                // write BOM asynchronously
                var bom = new byte[] { 0xEF, 0xBB, 0xBF };
                await writer.BaseStream.WriteAsync(bom, 0, bom.Length, ct).ConfigureAwait(false);
                await writer.FlushAsync().ConfigureAwait(false);

                var readerNames = Enumerable.Range(0, reader.FieldCount).Select(i => reader.GetName(i)).ToArray();
                var headerCols = columnOrder ?? readerNames;
                await writer.WriteLineAsync(string.Join(",", headerCols.Select(EscapeCsv))).ConfigureAwait(false);
                await writer.FlushAsync().ConfigureAwait(false);

                var ordinalMap = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
                for (int i = 0; i < reader.FieldCount; i++)
                    ordinalMap[reader.GetName(i)] = i;

                const int flushEvery = 256;
                int rowCount = 0;

                while (await reader.ReadAsync(ct).ConfigureAwait(false))
                {
                    var values = new string[headerCols.Length];

                    for (int i = 0; i < headerCols.Length; i++)
                    {
                        var colName = headerCols[i];
                        if (!ordinalMap.TryGetValue(colName, out var ord))
                        {
                            values[i] = "";
                            continue;
                        }

                        object? val = reader.IsDBNull(ord) ? null : reader.GetValue(ord);

                        if (val is DateTime dt) values[i] = dt.ToString("yyyy-MM-dd HH:mm:ss");
                        else values[i] = val?.ToString() ?? "";

                        values[i] = EscapeCsv(values[i]);
                    }

                    await writer.WriteLineAsync(string.Join(",", values)).ConfigureAwait(false);

                    rowCount++;
                    if ((rowCount % flushEvery) == 0)
                        await writer.FlushAsync().ConfigureAwait(false);

                    ct.ThrowIfCancellationRequested();
                }

                await writer.FlushAsync().ConfigureAwait(false);
            }
            finally
            {
                // Async dispose the writer to avoid sync Flush() inside Dispose
                // (.NET Core 3.0+ StreamWriter has DisposeAsync)
                try
                {
                    await writer.DisposeAsync().ConfigureAwait(false);
                }
                catch
                {
                    // swallow—caller owns outputStream; nothing more we can do here
                }
            }
        }

        // STREAM: Daily collection (calls sp_Report_DailyCollection)
        public Task StreamDailyCollectionCsvAsync(int orgId, DateTime from, DateTime to, string? mode, Stream output, CancellationToken ct = default)
        {
            var parameters = new { OrganizationId = orgId, FromDate = from.Date, ToDate = to.Date, PaymentMode = mode };
            // Provide header order if you expect specific column names from your SP
            var header = new[] { "CollectionDate", "PaymentsCount", "TotalCollected", "AllocatedAmount", "UnallocatedAmount" };
            return StreamFromReaderAsync("sp_Report_DailyCollection", parameters, output, header, ct);
        }

        // STREAM: Class-wise outstanding
        public Task StreamClassOutstandingCsvAsync(int orgId, int classId, int termId, int sessionId, Stream output, CancellationToken ct = default)
        {
            var parameters = new { OrganizationId = orgId, ClassId = classId, TermId = termId, SessionId = sessionId };
            var header = new[] { "ClassId", "ClassName", "InvoiceCount", "GrossAmount", "PaidAmount", "OutstandingAmount" };
            return StreamFromReaderAsync("sp_Report_ClassWiseOutstanding", parameters, output, header, ct);
        }

        // STREAM: Student outstanding (all)
        public Task StreamStudentOutstandingCsvAsync(int orgId, int classId, string? search, Stream output, CancellationToken ct = default)
        {
            var parameters = new { OrganizationId = orgId, ClassId = classId, Search = search };
            var header = new[] { "StudentId", "UserId", "AdmissionNo", "StudentName", "CurrentClassId", "TotalInvoiced", "TotalPaid", "Outstanding" };
            return StreamFromReaderAsync("sp_Report_StudentOutstanding_All", parameters, output, header, ct);
            // NOTE: if you don't have _All SP, use sp_Report_StudentOutstanding but ensure it returns all rows when PageSize large or create a dedicated _All SP.
        }

        // STREAM: Fee-type collection
        public Task StreamFeeTypeCollectionCsvAsync(int orgId, DateTime? from, DateTime? to, int termId, int sessionId, Stream output, CancellationToken ct = default)
        {
            var parameters = new { OrganizationId = orgId, FromDate = from, ToDate = to, TermId = termId, SessionId = sessionId };
            var header = new[] { "FeeTypeId", "FeeTypeName", "InvoicedAmount", "CollectedAmount", "OutstandingAmount" };
            return StreamFromReaderAsync("sp_Report_FeeTypeCollection", parameters, output, header, ct);
        }

        // STREAM: Student ledger
        public Task StreamStudentLedgerCsvAsync(int orgId, int studentId, DateTime? from, DateTime? to, Stream output, CancellationToken ct = default)
        {
            var parameters = new { OrganizationId = orgId, StudentId = studentId, FromDate = from, ToDate = to };
            var header = new[] { "TxnDate", "Description", "InvoiceId", "InvoiceItemId", "FeeTypeId", "FeeTypeName", "Debit", "Credit" };
            return StreamFromReaderAsync("sp_Report_StudentLedger", parameters, output, header, ct);
        }
    }
}
