using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Common;
using SchoolMgmt.Shared.Models.Subject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class SubjectService : ISubjectService
    {
        private readonly SubjectRepository _repository;

        public SubjectService(SubjectRepository repository)
        {
            _repository = repository;
        }

        public async Task<PaginatedResult<SubjectDto>> GetSubjectsAsync(int organizationId, int pageNumber, int pageSize)
        {
            var (records, totalCount) = await _repository.GetAllAsync(organizationId, pageNumber, pageSize);
            var dtoList = records.Select(s => new SubjectDto
            {
                SubjectId = s.SubjectId,
                SubjectName = s.SubjectName,
                SubjectCode = s.SubjectCode,
                Description = s.Description,
                IsActive = s.IsActive
            }).ToList();

            return new PaginatedResult<SubjectDto>
            {
                Records = dtoList,
                TotalRecords = totalCount,
                PageNumber = pageNumber,
                PageSize = pageSize
            };
        }

        public async Task<int> CreateSubjectAsync(int organizationId, SubjectDto dto, int createdBy)
        {
            var entity = new SubjectEntity
            {
                OrganizationId = organizationId,
                SubjectName = dto.SubjectName,
                SubjectCode = dto.SubjectCode,
                Description = dto.Description,
                CreatedBy = createdBy
            };
            return await _repository.CreateAsync(entity);
        }

        public async Task<SubjectDto?> GetSubjectByIdAsync(int organizationId, int subjectId)
        {
            var entity = await _repository.GetByIdAsync(organizationId, subjectId);
            return entity == null ? null : new SubjectDto
            {
                SubjectId = entity.SubjectId,
                SubjectName = entity.SubjectName,
                SubjectCode = entity.SubjectCode,
                Description = entity.Description,
                IsActive = entity.IsActive
            };
        }

        public async Task<bool> UpdateSubjectAsync(int organizationId, SubjectDto dto, int modifiedBy)
        {
            var entity = new SubjectEntity
            {
                OrganizationId = organizationId,
                SubjectId = dto.SubjectId,
                SubjectName = dto.SubjectName,
                SubjectCode = dto.SubjectCode,
                Description = dto.Description,
                IsActive = dto.IsActive,
                ModifiedBy = modifiedBy
            };
            return await _repository.UpdateAsync(entity);
        }

        public async Task<bool> DeleteSubjectAsync(int organizationId, int subjectId, int modifiedBy)
            => await _repository.DeleteAsync(organizationId, subjectId, modifiedBy);
    }
}
