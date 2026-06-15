using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Attendance
{
    public class DailyAttendanceReportDto
    {
        public int StudentId { get; set; }

        public string AdmissionNo { get; set; } = string.Empty;

        public string StudentName { get; set; } = string.Empty;

        public string ClassName { get; set; } = string.Empty;

        public string? SectionName { get; set; }

        public string Status { get; set; } = string.Empty;

        public string? Remarks { get; set; }
    }
}
