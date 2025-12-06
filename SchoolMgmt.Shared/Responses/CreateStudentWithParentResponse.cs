using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Responses
{
    public class CreateStudentWithParentResponse
    {
        public bool Success { get; set; }
        public string? Message { get; set; }

        /// <summary>
        /// Final ParentId used for student (existing or newly created)
        /// </summary>
        public int? ParentId { get; set; }

        /// <summary>
        /// Will have value only when a NEW parent user is created (ParentId == null in request)
        /// </summary>
        public int? NewParentUserId { get; set; }

        public int? StudentUserId { get; set; }
    }
}
