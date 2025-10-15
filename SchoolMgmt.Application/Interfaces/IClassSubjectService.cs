using SchoolMgmt.Shared.Models.Subject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IClassSubjectService
    {
        Task<IEnumerable<ClassSubjectDto>> GetByClassAsync(int organizationId, int classId);
        Task<int> AssignSubjectAsync(int organizationId, int classId, int subjectId, int createdBy);
        Task<bool> RemoveSubjectAsync(int organizationId, int classSubjectId, int modifiedBy);
    }
}
