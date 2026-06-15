using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Models.Attendance;

namespace SchoolMgmt.API.Controllers
{
    [Route("api/attendance")]
    [ApiController]
    public class AttendanceController : BaseController
    {
        private readonly IAttendanceService _attendanceService;

        public AttendanceController(
            IAttendanceService attendanceService)
        {
            _attendanceService = attendanceService;
        }

        [HttpGet("students")]
        public async Task<IActionResult> GetStudents(
            int classId,
            int? sectionId,
            DateTime attendanceDate)
        {
            var orgId = GetOrgIdFromClaims();

            var result =
                await _attendanceService
                    .GetStudentsForAttendanceAsync(
                        orgId,
                        classId,
                        sectionId,
                        attendanceDate);

            return Ok(result);
        }

        [HttpPost("mark")]
        public async Task<IActionResult> MarkAttendance(
            [FromBody] MarkAttendanceRequest request)
        {
            var orgId = GetOrgIdFromClaims();

            var userId = GetCurrentUserId();

            var result =
                await _attendanceService
                    .MarkAttendanceAsync(
                        orgId,
                        userId,
                        request);

            if (!result.Success)
                return BadRequest(result.Message);

            return Ok(result.Message);
        }
        [HttpGet("daily")]
        public async Task<IActionResult> DailyReport(
        DateTime attendanceDate,
        int? classId,
        int? sectionId,
        string? status)
        {
            var orgId = GetOrgIdFromClaims();

            var result =
                await _attendanceService
                    .GetDailyAttendanceReportAsync(
                        orgId,
                        attendanceDate,
                        classId,
                        sectionId,
                        status);

            return OkResponse(
                result,
                "Attendance report fetched successfully.");
        }
        [HttpGet("student")]
        public async Task<IActionResult> StudentHistory(
    int studentId,
    DateTime? fromDate,
    DateTime? toDate)
        {
            var orgId = GetOrgIdFromClaims();

            var result =
                await _attendanceService
                    .GetStudentAttendanceHistoryAsync(
                        orgId,
                        studentId,
                        fromDate,
                        toDate);

            return OkResponse(
                result,
                "Attendance history fetched successfully.");
        }
        [HttpGet("class-summary")]
        public async Task<IActionResult> ClassSummary(
    int classId,
    int? sectionId,
    int month,
    int year)
        {
            var orgId = GetOrgIdFromClaims();

            var result =
                await _attendanceService
                    .GetClassAttendanceSummaryAsync(
                        orgId,
                        classId,
                        sectionId,
                        month,
                        year);

            return OkResponse(
                result,
                "Class attendance summary fetched successfully.");
        }

        [HttpGet("monthly-register")]
        public async Task<IActionResult> MonthlyRegister(
    int classId,
    int? sectionId,
    int month,
    int year)
        {
            var orgId = GetOrgIdFromClaims();

            var result =
                await _attendanceService
                    .GetMonthlyAttendanceRegisterAsync(
                        orgId,
                        classId,
                        sectionId,
                        month,
                        year);

            return OkResponse(
                result,
                "Monthly attendance register fetched successfully.");
        }
        private int GetOrgIdFromClaims()
        {
            var claim = User.FindFirst("org");
            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
        private int GetCurrentUserId()
        {
            var claim = User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub)
                        ?? User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);

            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
    }
}
