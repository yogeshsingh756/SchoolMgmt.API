using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Models.Attendance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class AttendanceService : IAttendanceService
    {
        private readonly AttendanceRepository _attendanceRepository;

        public AttendanceService(
            AttendanceRepository attendanceRepository)
        {
            _attendanceRepository = attendanceRepository;
        }

        public async Task<IEnumerable<AttendanceStudentDto>>
            GetStudentsForAttendanceAsync(
            int organizationId,
            int classId,
            int? sectionId,
            DateTime attendanceDate)
        {
            return await _attendanceRepository
                .GetStudentsForAttendanceAsync(
                    organizationId,
                    classId,
                    sectionId,
                    attendanceDate);
        }

        public async Task<(bool Success, string Message)>
            MarkAttendanceAsync(
            int organizationId,
            int createdBy,
            MarkAttendanceRequest request)
        {
            return await _attendanceRepository
                .MarkAttendanceAsync(
                    organizationId,
                    createdBy,
                    request);
        }
        public async Task<IEnumerable<DailyAttendanceReportDto>>
    GetDailyAttendanceReportAsync(
        int organizationId,
        DateTime attendanceDate,
        int? classId,
        int? sectionId,
        string? status)
        {
            return await _attendanceRepository
                .GetDailyAttendanceReportAsync(
                    organizationId,
                    attendanceDate,
                    classId,
                    sectionId,
                    status);
        }
        public async Task<IEnumerable<StudentAttendanceHistoryDto>>
    GetStudentAttendanceHistoryAsync(
        int organizationId,
        int studentId,
        DateTime? fromDate,
        DateTime? toDate)
        {
            return await _attendanceRepository
                .GetStudentAttendanceHistoryAsync(
                    organizationId,
                    studentId,
                    fromDate,
                    toDate);
        }

        public async Task<IEnumerable<ClassAttendanceSummaryDto>>
    GetClassAttendanceSummaryAsync(
        int organizationId,
        int classId,
        int? sectionId,
        int month,
        int year)
        {
            return await _attendanceRepository
                .GetClassAttendanceSummaryAsync(
                    organizationId,
                    classId,
                    sectionId,
                    month,
                    year);
        }

        public async Task<IEnumerable<MonthlyAttendanceRegisterDto>>
    GetMonthlyAttendanceRegisterAsync(
        int organizationId,
        int classId,
        int? sectionId,
        int month,
        int year)
        {
            return await _attendanceRepository
                .GetMonthlyAttendanceRegisterAsync(
                    organizationId,
                    classId,
                    sectionId,
                    month,
                    year);
        }
    }
}
