using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class StudentAttendanceEntity
    {
        public long AttendanceId { get; set; }

        public int OrganizationId { get; set; }

        public int StudentId { get; set; }

        public int StudentUserId { get; set; }

        public int ClassId { get; set; }

        public int? SectionId { get; set; }

        public DateTime AttendanceDate { get; set; }

        public string Status { get; set; } = string.Empty;

        public string? Remarks { get; set; }

        public DateTime CreatedOn { get; set; }
    }
}
