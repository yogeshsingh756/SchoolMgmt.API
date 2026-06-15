using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Attendance
{
    public class AttendanceStudentDto
    {
        public int StudentId { get; set; }

        public int StudentUserId { get; set; }

        public string StudentName { get; set; } = string.Empty;

        public string AdmissionNo { get; set; } = string.Empty;

        public string? Status { get; set; }

        public string? Remarks { get; set; }
    }
}
