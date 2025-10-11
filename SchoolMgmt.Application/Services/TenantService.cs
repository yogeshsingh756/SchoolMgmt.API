using Dapper;
using SchoolMgmt.Application.DTOs.Tenants;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Interfaces;
using System.Data;
using TenantDto = SchoolMgmt.Application.DTOs.Tenants.TenantDto;

namespace SchoolMgmt.Application.Services
{
    public class TenantService : ITenantService
    {
        private readonly IDbConnectionFactory _dbFactory;

        public TenantService(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }

        public async Task<TenantRegistrationResultDto> RegisterTenantAsync(TenantRegistrationRequestDto request)
        {
            using var conn = _dbFactory.CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@p_SchoolName", request.SchoolName);
            parameters.Add("@p_Email", request.Email);
            parameters.Add("@p_Phone", request.Phone);
            parameters.Add("@p_Address", request.Address);
            parameters.Add("@p_PlanId", request.SubscriptionPlanId);
            parameters.Add("@p_AdminFirstName", request.AdminFirstName);
            parameters.Add("@p_AdminLastName", request.AdminLastName);
            parameters.Add("@p_AdminUsername", request.AdminUsername);
            parameters.Add("@p_AdminPassword", request.AdminPassword);
            parameters.Add("@p_AdminEmail", request.AdminEmail);

            var result = await conn.QueryFirstOrDefaultAsync<TenantRegistrationResultDto>(
                "sp_Tenant_Register",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            return result ?? new TenantRegistrationResultDto { Success = false, Message = "Tenant registration failed." };
        }

        public async Task<IEnumerable<DTOs.Tenants.TenantDto>> GetAllTenantsAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<TenantDto>("sp_Tenants_GetAll", commandType: CommandType.StoredProcedure);
        }

        public async Task<TenantDto?> GetTenantByIdAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<TenantDto>(
                "sp_Tenant_GetById",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure
            );
        }

        public async Task<bool> UpdateTenantAsync(UpdateTenantDto request)
        {
            using var conn = _dbFactory.CreateConnection();

            var rows = await conn.ExecuteAsync(
                "sp_Tenant_Update",
                new
                {
                    request.OrganizationId,
                    request.SchoolName,
                    request.Email,
                    request.Phone,
                    request.Address,
                    request.SubscriptionPlanId
                },
                commandType: CommandType.StoredProcedure
            );

            return rows > 0;
        }

        public async Task<bool> DeleteTenantAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            var rows = await conn.ExecuteAsync(
                "sp_Tenant_Delete",
                new { OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure
            );
            return rows > 0;
        }

        public async Task<bool> RenewSubscriptionAsync(int organizationId, int planId, bool isTrial, int? customMonths, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("@p_OrganizationId", organizationId);
            parameters.Add("@p_PlanId", planId);
            parameters.Add("@p_IsTrial", isTrial);
            parameters.Add("@p_StartAt", DateTime.UtcNow);
            parameters.Add("@p_CustomMonths", customMonths);
            parameters.Add("@p_CreatedBy", modifiedBy);
            parameters.Add("@o_TenantSubscriptionId", dbType: DbType.Int32, direction: ParameterDirection.Output);

            var rows = await conn.ExecuteAsync(
                "sp_TenantSubscription_Create",
                parameters,
                commandType: CommandType.StoredProcedure);

            return rows > 0;
        }
    }
}
