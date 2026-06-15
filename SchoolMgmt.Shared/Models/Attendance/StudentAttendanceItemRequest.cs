using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Attendance
{
    public class StudentAttendanceItemRequest
    {
        public int StudentId { get; set; }

        public string Status { get; set; } = string.Empty;

        public string? Remarks { get; set; }
    }
}
