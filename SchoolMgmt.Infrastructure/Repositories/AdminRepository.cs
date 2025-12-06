using Azure.Core;
using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models;
using SchoolMgmt.Shared.Models.Admin;
using SchoolMgmt.Shared.Responses;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class AdminRepository
    {
        private readonly IDbConnectionFactory _dbFactory;
        public AdminRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }
        public async Task<CreateStudentWithParentResponse> CreateStudentWithParentAsync(CreateStudentWithParentRequest model)
        {
            using var conn = _dbFactory.CreateConnection();

            var result = await conn.QueryFirstOrDefaultAsync<dynamic>(
                "sp_User_CreateStudentWithParent",
                new
                {
                    p_OrganizationId = model.OrganizationId,
                    p_CreatedBy = model.CreatedBy,

                    // Parent fields – only used when ParentId is null
                    p_ParentFirstName = model.IsExistingParent ? null : model.ParentFirstName,
                    p_ParentLastName = model.IsExistingParent ? null : model.ParentLastName,
                    p_ParentUsername = model.IsExistingParent ? null : model.ParentUsername,
                    p_ParentEmail = model.IsExistingParent ? null : model.ParentEmail,
                    p_ParentPasswordHash = model.IsExistingParent ? null : model.ParentPasswordHash,
                    p_ParentPhoneNumber = model.IsExistingParent ? null : model.ParentPhoneNumber,
                    p_ParentOccupation = model.IsExistingParent ? null : model.ParentOccupation,
                    p_ParentAddress = model.IsExistingParent ? null : model.ParentAddress,

                    // Student fields – always used
                    p_StudentFirstName = model.StudentFirstName,
                    p_StudentLastName = model.StudentLastName,
                    p_StudentUsername = model.StudentUsername,
                    p_StudentEmail = model.StudentEmail,
                    p_StudentPasswordHash = model.StudentPasswordHash,
                    p_StudentPhoneNumber = model.StudentPhoneNumber,
                    p_AdmissionNo = model.AdmissionNo,
                    p_ClassId = model.ClassId,

                    // Parent mode selector
                    p_ParentId = model.ParentId
                },
                commandType: CommandType.StoredProcedure
            );

            if (result == null)
            {
                return new CreateStudentWithParentResponse
                {
                    Success = false,
                    Message = "No response from stored procedure."
                };
            }

            return new CreateStudentWithParentResponse
            {
                Success = result.SuccessFlag == 1,
                Message = (string?)result.Message,
                ParentId = (int?)result.ParentId,
                NewParentUserId = (int?)result.NewParentUserId,   // null if existing parent
                StudentUserId = (int?)result.StudentUserId
            };
        }
        public async Task<(bool Success, string Message)> CreateUserAsync(
    int organizationId, string roleName, string firstName, string lastName,
    string username, string email, string passwordHash, string phoneNumber, int createdBy, string? qualification = null,
    string? designation = null,
    decimal? salary = null,
    string? occupation = null,
    string? address = null,
    string? admissionNo = null,
    int? parentId = null,
    int? classId = null)
        {
            using var conn = _dbFactory.CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@p_OrganizationId", organizationId);
            parameters.Add("@p_RoleName", roleName);
            parameters.Add("@p_FirstName", firstName);
            parameters.Add("@p_LastName", lastName);
            parameters.Add("@p_Username", username);
            parameters.Add("@p_Email", email);
            parameters.Add("@p_PasswordHash", passwordHash);
            parameters.Add("@p_CreatedBy", createdBy);
            parameters.Add("@p_PhoneNumber", phoneNumber);

            // Optional role-specific fields
            parameters.Add("@p_Qualification", qualification);
            parameters.Add("@p_Designation", designation);
            parameters.Add("@p_Salary", salary);
            parameters.Add("@p_Occupation", occupation);
            parameters.Add("@p_Address", address);
            parameters.Add("@p_AdmissionNo", admissionNo);
            parameters.Add("@p_ParentId", parentId);
            parameters.Add("@p_ClassId", classId);

            var result = await conn.QueryFirstOrDefaultAsync<SpResult>(
                "sp_User_Create", parameters, commandType: CommandType.StoredProcedure);

            if (result == null)
                return (false, "Procedure returned no response.");

            return (result.SuccessFlag == 1, result.Message);
        }

        public async Task<(bool Success, string Message)> UpdateUserAsync(
    int organizationId, int userId, string firstName, string lastName,
    string email, string phone, int modifiedBy,
    string? qualification = null,
    string? designation = null,
    decimal? salary = null,
    string? occupation = null,
    string? address = null,
    string? admissionNo = null,
    int? parentId = null,
    int? classId = null)
        {
            using var conn = _dbFactory.CreateConnection();
            var parameters = new DynamicParameters();

            parameters.Add("@p_OrganizationId", organizationId);
            parameters.Add("@p_UserId", userId);
            parameters.Add("@p_FirstName", firstName);
            parameters.Add("@p_LastName", lastName);
            parameters.Add("@p_Email", email);
            parameters.Add("@p_Phone", phone);
            parameters.Add("@p_ModifiedBy", modifiedBy);

            // Optional role-specific fields
            parameters.Add("@p_Qualification", qualification);
            parameters.Add("@p_Designation", designation);
            parameters.Add("@p_Salary", salary);
            parameters.Add("@p_Occupation", occupation);
            parameters.Add("@p_Address", address);
            parameters.Add("@p_AdmissionNo", admissionNo);
            parameters.Add("@p_ParentId", parentId);
            parameters.Add("@p_ClassId", classId);

            var result = await conn.QueryFirstOrDefaultAsync<SpResult>(
                "sp_User_Update", parameters, commandType: CommandType.StoredProcedure);

            if (result == null)
                return (false, "Procedure returned no response.");

            return (result.SuccessFlag == 1, result.Message);
        }

        public async Task<(bool Success, string Message)> SoftDeleteUserAsync(int organizationId, int userId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var parameters = new DynamicParameters();
            parameters.Add("@p_OrganizationId", organizationId);
            parameters.Add("@p_UserId", userId);
            parameters.Add("@p_ModifiedBy", modifiedBy);

            var result = await conn.QueryFirstOrDefaultAsync<SpResult>(
                "sp_User_SoftDelete", parameters, commandType: CommandType.StoredProcedure);

            if (result == null)
                return (false, "Procedure returned no response.");

            return (result.SuccessFlag == 1, result.Message);
        }

        public async Task<(IEnumerable<AdminUserDbEntity> Users, int TotalCount)> GetAllUsersAsync(
             int organizationId, int pageNumber, int pageSize, string? search, string? statusFilter)
        {
            using var conn = _dbFactory.CreateConnection();

            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_User_GetAll",
                new
                {
                    p_OrganizationId = organizationId,
                    p_PageNumber = pageNumber,
                    p_PageSize = pageSize,
                    p_Search = search,
                    p_StatusFilter = statusFilter
                },
                commandType: CommandType.StoredProcedure
            );

            var users = await multi.ReadAsync<AdminUserDbEntity>();
            var total = await multi.ReadFirstAsync<int>();

            return (users, total);
        }

        public async Task<StudentEditDto?> GetStudentByIdAsync(int organizationId, int studentUserId)
        {
            using var conn = _dbFactory.CreateConnection();

            var result = await conn.QueryFirstOrDefaultAsync<StudentEditDto>(
                "sp_Admin_Student_GetById",
                new
                {
                    p_OrganizationId = organizationId,
                    p_StudentUserId = studentUserId
                },
                commandType: CommandType.StoredProcedure
            );

            // null => not found or inactive or not a student in this org
            return result;
        }

        public async Task<(IEnumerable<AdminUserDbEntity> Users, int TotalCount)> GetAllStudentUsersAsync(
            int organizationId, int pageNumber, int pageSize, string? search, string? statusFilter)
        {
            using var conn = _dbFactory.CreateConnection();

            using var multi = await conn.QueryMultipleAsync(
                "sp_Admin_Student_GetAll",
                new
                {
                    p_OrganizationId = organizationId,
                    p_PageNumber = pageNumber,
                    p_PageSize = pageSize,
                    p_Search = search,
                    p_StatusFilter = statusFilter
                },
                commandType: CommandType.StoredProcedure
            );

            var users = await multi.ReadAsync<AdminUserDbEntity>();
            var total = await multi.ReadFirstAsync<int>();

            return (users, total);
        }
        public async Task<AdminDashboard> GetDashboardAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstAsync<AdminDashboard>(
                "sp_Admin_Dashboard_GetOverview",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<AdminUser>> GetUsersByOrganizationAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<AdminUser>(
                "sp_Admin_User_GetAll",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<DbRole>> GetAssignableRolesForAdminAsync(int adminId)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_AdminId", adminId);

            return await conn.QueryAsync<DbRole>(
                "sp_Roles_GetAssignableByAdmin",
                p,
                commandType: CommandType.StoredProcedure
            );
        }
        public async Task<PaginatedResponse<ParentDto>> GetParentsAsync(int PageNumber, int PageSize, string SearchTerm, int orgId)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_OrgId", orgId);
            p.Add("p_PageNumber", PageNumber);
            p.Add("p_PageSize", PageSize);
            p.Add("p_Search", SearchTerm);

            using var multi = await conn.QueryMultipleAsync("sp_Admin_Parents_GetAll", p, commandType: CommandType.StoredProcedure);

            var items = multi.Read<ParentDto>().ToList();
            var total = multi.ReadFirst<int>();

            return new PaginatedResponse<ParentDto>
            {
                Data = items,
                PageNumber = PageNumber,
                PageSize = PageSize,
                TotalCount = total
            };
        }
    }
}
