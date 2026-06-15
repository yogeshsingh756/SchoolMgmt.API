using SchoolMgmt.Shared.Models.Attendance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IAttendanceService
    {
        Task<IEnumerable<AttendanceStudentDto>> GetStudentsForAttendanceAsync(
            int organizationId,
            int classId,
            int? sectionId,
            DateTime attendanceDate);

        Task<(bool Success, string Message)> MarkAttendanceAsync(
            int organizationId,
            int createdBy,
            MarkAttendanceRequest request);

        Task<IEnumerable<DailyAttendanceReportDto>>
    GetDailyAttendanceReportAsync(
        int organizationId,
        DateTime attendanceDate,
        int? classId,
        int? sectionId,
        string? status);

        Task<IEnumerable<StudentAttendanceHistoryDto>>
    GetStudentAttendanceHistoryAsync(
        int organizationId,
        int studentId,
        DateTime? fromDate,
        DateTime? toDate);
        Task<IEnumerable<ClassAttendanceSummaryDto>>
    GetClassAttendanceSummaryAsync(
        int organizationId,
        int classId,
        int? sectionId,
        int month,
        int year);

        Task<IEnumerable<MonthlyAttendanceRegisterDto>>
    GetMonthlyAttendanceRegisterAsync(
        int organizationId,
        int classId,
        int? sectionId,
        int month,
        int year);
    }
}
