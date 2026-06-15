using Dapper;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models;
using SchoolMgmt.Shared.Models.Attendance;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class AttendanceRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public AttendanceRepository(
            IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<IEnumerable<AttendanceStudentDto>>
            GetStudentsForAttendanceAsync(
            int organizationId,
            int classId,
            int? sectionId,
            DateTime attendanceDate)
        {
            using var conn = _dbFactory.CreateConnection();

            return await conn.QueryAsync<AttendanceStudentDto>(
                "sp_Attendance_GetStudents",
                new
                {
                    p_OrganizationId = organizationId,
                    p_ClassId = classId,
                    p_SectionId = sectionId,
                    p_AttendanceDate = attendanceDate.Date
                },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool Success, string Message)>
            MarkAttendanceAsync(
            int organizationId,
            int createdBy,
            MarkAttendanceRequest request)
        {
            using var conn = _dbFactory.CreateConnection();

            string attendanceJson =
                JsonSerializer.Serialize(request.Students);

            var result =
                await conn.QueryFirstOrDefaultAsync<SpResult>(
                    "sp_Attendance_Mark",
                    new
                    {
                        p_OrganizationId = organizationId,
                        p_CreatedBy = createdBy,
                        p_AttendanceDate = request.AttendanceDate.Date,
                        p_ClassId = request.ClassId,
                        p_SectionId = request.SectionId,
                        p_AttendanceJson = attendanceJson
                    },
                    commandType: CommandType.StoredProcedure);

            if (result == null)
                return (false, "No response from procedure.");

            return (
                result.SuccessFlag == 1,
                result.Message
            );
        }

        public async Task<IEnumerable<DailyAttendanceReportDto>>
    GetDailyAttendanceReportAsync(
        int organizationId,
        DateTime attendanceDate,
        int? classId,
        int? sectionId,
        string? status)
        {
            using var conn = _dbFactory.CreateConnection();

            return await conn.QueryAsync<DailyAttendanceReportDto>(
                "sp_Attendance_DailyReport",
                new
                {
                    p_OrganizationId = organizationId,
                    p_AttendanceDate = attendanceDate,
                    p_ClassId = classId,
                    p_SectionId = sectionId,
                    p_Status = status
                },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<StudentAttendanceHistoryDto>>
    GetStudentAttendanceHistoryAsync(
        int organizationId,
        int studentId,
        DateTime? fromDate,
        DateTime? toDate)
        {
            using var conn = _dbFactory.CreateConnection();

            return await conn.QueryAsync<StudentAttendanceHistoryDto>(
                "sp_Attendance_StudentHistory",
                new
                {
                    p_OrganizationId = organizationId,
                    p_StudentId = studentId,
                    p_FromDate = fromDate,
                    p_ToDate = toDate
                },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<ClassAttendanceSummaryDto>>
    GetClassAttendanceSummaryAsync(
        int organizationId,
        int classId,
        int? sectionId,
        int month,
        int year)
        {
            using var conn = _dbFactory.CreateConnection();

            return await conn.QueryAsync<ClassAttendanceSummaryDto>(
                "sp_Attendance_ClassSummary",
                new
                {
                    p_OrganizationId = organizationId,
                    p_ClassId = classId,
                    p_SectionId = sectionId,
                    p_Month = month,
                    p_Year = year
                },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<MonthlyAttendanceRegisterDto>>
    GetMonthlyAttendanceRegisterAsync(
        int organizationId,
        int classId,
        int? sectionId,
        int month,
        int year)
        {
            using var conn = _dbFactory.CreateConnection();

            return await conn.QueryAsync<MonthlyAttendanceRegisterDto>(
                "sp_Attendance_MonthlyRegister",
                new
                {
                    p_OrganizationId = organizationId,
                    p_ClassId = classId,
                    p_SectionId = sectionId,
                    p_Month = month,
                    p_Year = year
                },
                commandType: CommandType.StoredProcedure);
        }
    }
}
