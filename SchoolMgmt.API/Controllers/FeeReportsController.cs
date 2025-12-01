using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/reports/fees")]
    [Authorize]
    public class FeeReportsController : BaseController
    {
        private readonly IFeeReportService _svc;
        public FeeReportsController(IFeeReportService svc) => _svc = svc;

        // GET /api/admin/reports/fees/daily?from=yyyy-mm-dd&to=yyyy-mm-dd&mode=UPI
        [HttpGet("daily")]
        public async Task<IActionResult> GetDaily([FromQuery] DateTime from, [FromQuery] DateTime to, [FromQuery] string? mode)
        {
            var orgId = GetOrgIdFromClaims();
            var data = await _svc.GetDailyCollectionAsync(orgId, from, to, mode);
            return OkResponse(data, "Daily collection fetched.");
        }

        // GET /api/admin/reports/fees/class-outstanding
        [HttpGet("class-outstanding")]
        public async Task<IActionResult> GetClassOutstanding([FromQuery] int classId = 0, [FromQuery] int termId = 0, [FromQuery] int sessionId = 0)
        {
            var orgId = GetOrgIdFromClaims();
            var data = await _svc.GetClassOutstandingAsync(orgId, classId, termId, sessionId);
            return OkResponse(data, "Class-wise outstanding fetched.");
        }

        // GET /api/admin/reports/fees/student-outstanding?page=1&size=20&search=&classId=0
        [HttpGet("student-outstanding")]
        public async Task<IActionResult> GetStudentOutstanding([FromQuery] int page = 1, [FromQuery] int size = 20, [FromQuery] string? search = null, [FromQuery] int classId = 0)
        {
            var orgId = GetOrgIdFromClaims();
            var data = await _svc.GetStudentOutstandingAsync(orgId, classId, search, page, size);
            return OkResponse(data, "Student outstanding fetched.");
        }

        // GET /api/admin/reports/fees/fee-type-collection?from=&to=&termId=&sessionId=
        [HttpGet("fee-type-collection")]
        public async Task<IActionResult> GetFeeTypeCollection([FromQuery] DateTime? from = null, [FromQuery] DateTime? to = null, [FromQuery] int termId = 0, [FromQuery] int sessionId = 0)
        {
            var orgId = GetOrgIdFromClaims();
            var data = await _svc.GetFeeTypeCollectionAsync(orgId, from, to, termId, sessionId);
            return OkResponse(data, "Fee type collection fetched.");
        }

        // GET /api/admin/reports/fees/student-ledger?studentId=10&from=&to=
        [HttpGet("student-ledger")]
        public async Task<IActionResult> GetStudentLedger([FromQuery] int studentId, [FromQuery] DateTime? from = null, [FromQuery] DateTime? to = null)
        {
            if (studentId <= 0) return BadRequestResponse("Invalid student id.");
            var orgId = GetOrgIdFromClaims();
            var data = await _svc.GetStudentLedgerAsync(orgId, studentId, from, to);
            return OkResponse(data, "Student ledger fetched.");
        }

        // ---------------- CSV STREAMING ENDPOINTS ---------------- //

        [HttpGet("daily/csv/stream")]
        public async Task<IActionResult> StreamDailyCsv(
            [FromQuery] DateTime from,
            [FromQuery] DateTime to,
            [FromQuery] string? mode = null,
            CancellationToken ct = default)
        {
            var orgId = GetOrgIdFromClaims();
            var filename = $"daily-collection-{from:yyyyMMdd}-{to:yyyyMMdd}.csv";
            SetCsvHeaders(Response, filename);

            try
            {
                await _svc.StreamDailyCollectionCsvAsync(orgId, from, to, mode, Response.Body, ct);
            }
            catch (OperationCanceledException)
            {
                // client cancelled — safe to ignore
            }
            catch (Exception ex)
            {
                LogCsvError(ex, Response);
            }

            return new EmptyResult();
        }

        [HttpGet("class-outstanding/csv/stream")]
        public async Task<IActionResult> StreamClassOutstandingCsv(
            [FromQuery] int classId = 0,
            [FromQuery] int termId = 0,
            [FromQuery] int sessionId = 0,
            CancellationToken ct = default)
        {
            var orgId = GetOrgIdFromClaims();
            var filename = $"class-outstanding-{DateTime.UtcNow:yyyyMMddHHmmss}.csv";
            SetCsvHeaders(Response, filename);

            try
            {
                await _svc.StreamClassOutstandingCsvAsync(orgId, classId, termId, sessionId, Response.Body, ct);
            }
            catch (OperationCanceledException)
            {
            }
            catch (Exception ex)
            {
                LogCsvError(ex, Response);
            }

            return new EmptyResult();
        }

        [HttpGet("student-outstanding/csv/stream")]
        public async Task<IActionResult> StreamStudentOutstandingCsv(
            [FromQuery] int classId = 0,
            [FromQuery] string? search = null,
            CancellationToken ct = default)
        {
            var orgId = GetOrgIdFromClaims();
            var filename = $"student-outstanding-{DateTime.UtcNow:yyyyMMddHHmmss}.csv";
            SetCsvHeaders(Response, filename);

            try
            {
                await _svc.StreamStudentOutstandingCsvAsync(orgId, classId, search, Response.Body, ct);
            }
            catch (OperationCanceledException)
            {
            }
            catch (Exception ex)
            {
                LogCsvError(ex, Response);
            }

            return new EmptyResult();
        }

        [HttpGet("fee-type-collection/csv/stream")]
        public async Task<IActionResult> StreamFeeTypeCollectionCsv(
            [FromQuery] DateTime? from = null,
            [FromQuery] DateTime? to = null,
            [FromQuery] int termId = 0,
            [FromQuery] int sessionId = 0,
            CancellationToken ct = default)
        {
            var orgId = GetOrgIdFromClaims();
            var filename = $"fee-type-collection-{DateTime.UtcNow:yyyyMMddHHmmss}.csv";
            SetCsvHeaders(Response, filename);

            try
            {
                await _svc.StreamFeeTypeCollectionCsvAsync(orgId, from, to, termId, sessionId, Response.Body, ct);
            }
            catch (OperationCanceledException)
            {
            }
            catch (Exception ex)
            {
                LogCsvError(ex, Response);
            }

            return new EmptyResult();
        }

        [HttpGet("student-ledger/csv/stream")]
        public async Task<IActionResult> StreamStudentLedgerCsv(
            [FromQuery] int studentId,
            [FromQuery] DateTime? from = null,
            [FromQuery] DateTime? to = null,
            CancellationToken ct = default)
        {
            if (studentId <= 0)
                return BadRequestResponse("Invalid student id.");

            var orgId = GetOrgIdFromClaims();
            var filename = $"student-ledger-{studentId}-{DateTime.UtcNow:yyyyMMddHHmmss}.csv";
            SetCsvHeaders(Response, filename);

            try
            {
                await _svc.StreamStudentLedgerCsvAsync(orgId, studentId, from, to, Response.Body, ct);
            }
            catch (OperationCanceledException)
            {
            }
            catch (Exception ex)
            {
                LogCsvError(ex, Response);
            }

            return new EmptyResult();
        }

        private void LogCsvError(Exception ex, HttpResponse response)
        {
            // log exception
            Console.WriteLine("CSV Streaming Error: " + ex);

            try
            {
                // write error footer inside CSV (safe, NOT JSON)
                var footer = $"\n\"ERROR\",\"{ex.Message.Replace("\"", "'")}\"";
                var bytes = System.Text.Encoding.UTF8.GetBytes(footer);

                // do NOT modify headers here
                response.Body.Write(bytes, 0, bytes.Length);
            }
            catch
            {
                // ignore – response is already in streaming mode
            }
        }

        // helper: reuse your BaseController's claim helpers
        private int GetOrgIdFromClaims()
        {
            var claim = User.FindFirst("org");
            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
        private void SetCsvHeaders(HttpResponse response, string filename)
        {
            response.ContentType = "text/csv; charset=utf-8";
            response.Headers["Content-Disposition"] = $"attachment; filename=\"{filename}\"";
            // optionally: response.Headers["Cache-Control"] = "no-store";
        }
    }
}
