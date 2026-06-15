using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Attendance
{
    public class MarkAttendanceRequest
    {
        public DateTime AttendanceDate { get; set; }

        public int ClassId { get; set; }

        public int? SectionId { get; set; }

        public List<StudentAttendanceItemRequest> Students { get; set; }
            = new();
    }
}
