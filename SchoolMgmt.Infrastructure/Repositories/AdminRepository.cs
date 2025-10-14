using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models;
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
    }
}
