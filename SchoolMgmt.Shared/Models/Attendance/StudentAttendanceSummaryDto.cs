using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Attendance
{
    public class StudentAttendanceSummaryDto
    {
        public int PresentDays { get; set; }

        public int AbsentDays { get; set; }

        public int LateDays { get; set; }

        public int HalfDays { get; set; }

        public decimal AttendancePercentage { get; set; }
    }
}
