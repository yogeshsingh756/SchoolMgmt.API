using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class ClassSectionRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public ClassSectionRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        // 🔹 Get all classes for this organization
        public async Task<IEnumerable<ClassEntity>> GetAllClassesAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<ClassEntity>(
                "sp_Admin_Classes_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        // 🔹 Create new class
        public async Task<(int ClassId, string Message)> CreateClassAsync(ClassEntity entity)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_OrganizationId", entity.OrganizationId);
            p.Add("p_ClassName", entity.ClassName);
            p.Add("p_Description", entity.Description);
            p.Add("p_ClassTeacherId", entity.ClassTeacherId);
            p.Add("p_AcademicYear", entity.AcademicYear);
            p.Add("p_OrderNo", entity.OrderNo);
            p.Add("p_CreatedBy", entity.CreatedBy);

            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Classes_Create", p, commandType: CommandType.StoredProcedure);

            return ((int)result.ClassId, (string)result.Message);
        }

        // 🔹 Update class
        public async Task<(bool Success, string Message)> UpdateClassAsync(ClassEntity entity)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new
            {
                p_ClassId = entity.ClassId,
                p_OrganizationId = entity.OrganizationId,
                p_ClassName = entity.ClassName,
                p_Description = entity.Description,
                p_ClassTeacherId = entity.ClassTeacherId,
                p_AcademicYear = entity.AcademicYear,
                p_OrderNo = entity.OrderNo,
                p_IsActive = entity.IsActive,
                p_ModifiedBy = entity.ModifiedBy
            };

            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Classes_Update", p, commandType: CommandType.StoredProcedure);

            return (true, result.Message);
        }

        // 🔹 Delete class
        public async Task<(bool Success, string Message)> DeleteClassAsync(int classId, int organizationId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Classes_Delete",
                new { p_ClassId = classId, p_OrganizationId = organizationId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return (true, result.Message);
        }

        // 🔹 Get all sections for a class
        public async Task<IEnumerable<SectionEntity>> GetSectionsByClassAsync(int organizationId, int? classId = null, bool includeInactive = false)
        {
            using var conn = _dbFactory.CreateConnection();

            var parameters = new
            {
                p_OrganizationId = organizationId,
                p_ClassId = classId,
                p_IncludeInactive = includeInactive ? 1 : 0
            };

            return await conn.QueryAsync<SectionEntity>(
                "sp_Admin_Sections_GetAll",
                parameters,
                commandType: CommandType.StoredProcedure
            );
        }

        // 🔹 Create section
        public async Task<(int SectionId, string Message)> CreateSectionAsync(SectionEntity entity)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_OrganizationId", entity.OrganizationId);
            p.Add("p_ClassId", entity.ClassId);
            p.Add("p_SectionName", entity.SectionName);
            p.Add("p_ClassTeacherId", entity.ClassTeacherId);
            p.Add("p_Capacity", entity.Capacity);
            p.Add("p_Description", entity.Description);
            p.Add("p_CreatedBy", entity.CreatedBy);

            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Sections_Create", p, commandType: CommandType.StoredProcedure);
            return ((int)result.SectionId, (string)result.Message);
        }

        // 🔹 Update section
        public async Task<(bool Success, string Message)> UpdateSectionAsync(SectionEntity entity)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new
            {
                p_SectionId = entity.SectionId,
                p_OrganizationId = entity.OrganizationId,
                p_SectionName = entity.SectionName,
                p_ClassTeacherId = entity.ClassTeacherId,
                p_Capacity = entity.Capacity,
                p_Description = entity.Description,
                p_IsActive = entity.IsActive,
                p_ModifiedBy = entity.ModifiedBy
            };

            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Sections_Update", p, commandType: CommandType.StoredProcedure);
            return (true, result.Message);
        }

        // 🔹 Delete section
        public async Task<(bool Success, string Message)> DeleteSectionAsync(int sectionId, int organizationId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var result = await conn.QueryFirstAsync<dynamic>(
                "sp_Admin_Sections_Delete",
                new { p_SectionId = sectionId, p_OrganizationId = organizationId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return (true, result.Message);
        }
    }
}
