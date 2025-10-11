using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Admin
{
    public class AdminDashboardDto
    {
        public int TotalStudents { get; set; }
        public int ActiveStudents { get; set; }
        public int InactiveStudents { get; set; }

        public int TotalTeachers { get; set; }
        public int ActiveTeachers { get; set; }
        public int InactiveTeachers { get; set; }

        public int TotalParents { get; set; }
        public int ActiveParents { get; set; }
        public int InactiveParents { get; set; }

        public int TotalCourses { get; set; }
        public int TotalClasses { get; set; }
    }
}
