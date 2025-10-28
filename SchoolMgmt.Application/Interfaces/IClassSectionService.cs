using SchoolMgmt.Application.DTOs.Admin;
using SchoolMgmt.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IClassSectionService
    {
        Task<IEnumerable<ClassDto>> GetAllClassesAsync(int organizationId);
        Task<(int ClassId, string Message)> CreateClassAsync(ClassDto dto, int organizationId, int createdBy);
        Task<(bool Success, string Message)> UpdateClassAsync(ClassDto dto, int organizationId, int modifiedBy);
        Task<(bool Success, string Message)> DeleteClassAsync(int classId, int organizationId, int modifiedBy);

        Task<IEnumerable<SectionDto>> GetSectionsByClassAsync(int organizationId, int classId,bool isActive);
        Task<(int SectionId, string Message)> CreateSectionAsync(SectionDto dto, int organizationId, int createdBy);
        Task<(bool Success, string Message)> UpdateSectionAsync(SectionDto dto, int organizationId, int modifiedBy);
        Task<(bool Success, string Message)> DeleteSectionAsync(int sectionId, int organizationId, int modifiedBy);

        Task<IEnumerable<TeacherDropdown>> GetTeachersByOrganizationAsync(int organizationId);
    }
}
