using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Models.Subject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class TeacherSubjectService : ITeacherSubjectService
    {
        private readonly TeacherSubjectRepository _repository;

        public TeacherSubjectService(TeacherSubjectRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<TeacherSubjectDto>> GetByTeacherAsync(int organizationId, int teacherId)
        {
            var list = await _repository.GetByTeacherAsync(organizationId, teacherId);
            return list.Select(x => new TeacherSubjectDto
            {
                TeacherSubjectId = x.TeacherSubjectId,
                TeacherId = x.TeacherId,
                ClassId = x.ClassId,
                SectionId = x.SectionId,
                SubjectId = x.SubjectId,
                IsPrimary = x.IsPrimary,
                IsActive = x.IsActive
            });
        }

        public async Task<int> AssignAsync(int organizationId, int teacherId, int classId, int? sectionId, int subjectId, bool isPrimary, int createdBy)
        {
            var entity = new TeacherSubjectEntity
            {
                OrganizationId = organizationId,
                TeacherId = teacherId,
                ClassId = classId,
                SectionId = sectionId,
                SubjectId = subjectId,
                IsPrimary = isPrimary,
                CreatedBy = createdBy
            };
            return await _repository.AssignAsync(entity);
        }

        public async Task<bool> UnassignAsync(int organizationId, int teacherSubjectId, int modifiedBy)
            => await _repository.UnassignAsync(organizationId, teacherSubjectId, modifiedBy);
    }
}
