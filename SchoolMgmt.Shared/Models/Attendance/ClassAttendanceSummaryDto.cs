using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Attendance
{
    public class ClassAttendanceSummaryDto
    {
        public int StudentId { get; set; }

        public string StudentName { get; set; } = string.Empty;

        public int PresentDays { get; set; }

        public int AbsentDays { get; set; }

        public int LateDays { get; set; }

        public int HalfDays { get; set; }

        public decimal AttendancePercentage { get; set; }
    }
}
