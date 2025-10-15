using SchoolMgmt.Shared.Models.Subject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface ITeacherSubjectService
    {
        Task<IEnumerable<TeacherSubjectDto>> GetByTeacherAsync(int organizationId, int teacherId);
        Task<int> AssignAsync(int organizationId, int teacherId, int classId, int? sectionId, int subjectId, bool isPrimary, int createdBy);
        Task<bool> UnassignAsync(int organizationId, int teacherSubjectId, int modifiedBy);
    }
}
