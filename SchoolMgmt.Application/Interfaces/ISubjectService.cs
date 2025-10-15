using SchoolMgmt.Shared.Common;
using SchoolMgmt.Shared.Models.Subject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface ISubjectService
    {
        Task<PaginatedResult<SubjectDto>> GetSubjectsAsync(int organizationId, int pageNumber, int pageSize);
        Task<int> CreateSubjectAsync(int organizationId, SubjectDto dto, int createdBy);
        Task<SubjectDto?> GetSubjectByIdAsync(int organizationId, int subjectId);
        Task<bool> UpdateSubjectAsync(int organizationId, SubjectDto dto, int modifiedBy);
        Task<bool> DeleteSubjectAsync(int organizationId, int subjectId, int modifiedBy);
    }
}
