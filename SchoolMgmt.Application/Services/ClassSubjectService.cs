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
    public class ClassSubjectService : IClassSubjectService
    {
        private readonly ClassSubjectRepository _repository;

        public ClassSubjectService(ClassSubjectRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<ClassSubjectDto>> GetByClassAsync(int organizationId, int classId)
        {
            var list = await _repository.GetByClassAsync(organizationId, classId);
            return list.Select(x => new ClassSubjectDto
            {
                ClassSubjectId = x.ClassSubjectId,
                ClassId = x.ClassId,
                SubjectId = x.SubjectId,
                IsActive = x.IsActive,
                SubjectName = x.SubjectName
            });
        }

        public async Task<int> AssignSubjectAsync(int organizationId, int classId, int subjectId, int createdBy)
        {
            var entity = new ClassSubjectEntity
            {
                OrganizationId = organizationId,
                ClassId = classId,
                SubjectId = subjectId,
                CreatedBy = createdBy
            };
            return await _repository.CreateAsync(entity);
        }

        public async Task<bool> RemoveSubjectAsync(int organizationId, int classSubjectId, int modifiedBy)
            => await _repository.DeleteAsync(organizationId, classSubjectId, modifiedBy);
    }
}
