using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Attendance
{
    public class MonthlyAttendanceRegisterDto
    {
        public int StudentId { get; set; }

        public string AdmissionNo { get; set; } = string.Empty;

        public string StudentName { get; set; } = string.Empty;

        public int ClassId { get; set; }

        public int? SectionId { get; set; }

        public int DayNo { get; set; }

        public string AttendanceStatus { get; set; } = string.Empty;
    }
}
