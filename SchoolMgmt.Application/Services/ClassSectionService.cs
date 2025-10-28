using SchoolMgmt.Application.DTOs.Admin;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class ClassSectionService : IClassSectionService
    {
        private readonly ClassSectionRepository _repo;

        public ClassSectionService(ClassSectionRepository repo)
        {
            _repo = repo;
        }

        public async Task<IEnumerable<ClassDto>> GetAllClassesAsync(int organizationId)
        {
            var data = await _repo.GetAllClassesAsync(organizationId);
            return data.Select(c => new ClassDto
            {
                ClassId = c.ClassId,
                ClassName = c.ClassName,
                Description = c.Description,
                AcademicYear = c.AcademicYear,
                ClassTeacherId = c.ClassTeacherId,
                ClassTeacherName = c.ClassTeacherName,
                OrderNo = c.OrderNo,
                IsActive = c.IsActive
            });
        }

        public async Task<(int ClassId, string Message)> CreateClassAsync(ClassDto dto, int organizationId, int createdBy)
        {
            var entity = new ClassEntity
            {
                OrganizationId = organizationId,
                ClassName = dto.ClassName,
                Description = dto.Description,
                ClassTeacherId = dto.ClassTeacherId,
                AcademicYear = dto.AcademicYear,
                OrderNo = dto.OrderNo,
                CreatedBy = createdBy
            };
            return await _repo.CreateClassAsync(entity);
        }

        public async Task<(bool Success, string Message)> UpdateClassAsync(ClassDto dto, int organizationId, int modifiedBy)
        {
            var entity = new ClassEntity
            {
                ClassId = dto.ClassId,
                OrganizationId = organizationId,
                ClassName = dto.ClassName,
                Description = dto.Description,
                ClassTeacherId = dto.ClassTeacherId,
                AcademicYear = dto.AcademicYear,
                OrderNo = dto.OrderNo,
                IsActive = dto.IsActive,
                ModifiedBy = modifiedBy
            };
            return await _repo.UpdateClassAsync(entity);
        }

        public Task<(bool Success, string Message)> DeleteClassAsync(int classId, int organizationId, int modifiedBy)
            => _repo.DeleteClassAsync(classId, organizationId, modifiedBy);

        public Task<IEnumerable<SectionDto>> GetSectionsByClassAsync(int organizationId, int classId, bool isActive)
            => _repo.GetSectionsByClassAsync(organizationId, classId)
                .ContinueWith(t => t.Result.Select(s => new SectionDto
                {
                    SectionId = s.SectionId,
                    SectionName = s.SectionName,
                    Description = s.Description,
                    Capacity = s.Capacity,
                    ClassId = s.ClassId,
                    ClassTeacherId = s.ClassTeacherId,
                    ClassTeacherName = s.ClassTeacherName,
                    IsActive = s.IsActive
                }));

        public Task<(int SectionId, string Message)> CreateSectionAsync(SectionDto dto, int organizationId, int createdBy)
        {
            var entity = new SectionEntity
            {
                OrganizationId = organizationId,
                ClassId = dto.ClassId,
                SectionName = dto.SectionName,
                Description = dto.Description,
                Capacity = dto.Capacity,
                ClassTeacherId = dto.ClassTeacherId,
                CreatedBy = createdBy
            };
            return _repo.CreateSectionAsync(entity);
        }

        public Task<(bool Success, string Message)> UpdateSectionAsync(SectionDto dto, int organizationId, int modifiedBy)
        {
            var entity = new SectionEntity
            {
                SectionId = dto.SectionId,
                OrganizationId = organizationId,
                SectionName = dto.SectionName,
                Description = dto.Description,
                Capacity = dto.Capacity,
                ClassTeacherId = dto.ClassTeacherId,
                IsActive = dto.IsActive,
                ModifiedBy = modifiedBy
            };
            return _repo.UpdateSectionAsync(entity);
        }

        public Task<(bool Success, string Message)> DeleteSectionAsync(int sectionId, int organizationId, int modifiedBy)
            => _repo.DeleteSectionAsync(sectionId, organizationId, modifiedBy);
        public async Task<IEnumerable<TeacherDropdown>> GetTeachersByOrganizationAsync(int organizationId)
        {
            var teachers = await _repo.GetTeachersByOrganizationAsync(organizationId);
            return teachers;
        }
    }
}
