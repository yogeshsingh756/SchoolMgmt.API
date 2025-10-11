using Dapper;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Shared.Interfaces;
using System.Data;

namespace SchoolMgmt.Infrastructure.Repositories
{
    public class SuperAdminRepository
    {
        private readonly IDbConnectionFactory _dbFactory;

        public SuperAdminRepository(IDbConnectionFactory dbFactory)
        {
            _dbFactory = dbFactory;
        }
        public async Task<IEnumerable<SubscriptionPlanDbEntity>> GetAllPlansAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<SubscriptionPlanDbEntity>(
                "sp_SubscriptionPlan_GetAll", commandType: CommandType.StoredProcedure);
        }
        public async Task<int> CreatePlanAsync(SubscriptionPlanDbEntity plan, int createdBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_PlanName", plan.PlanName);
            p.Add("p_Description", plan.Description);
            p.Add("p_Price", plan.Price);
            p.Add("p_BillingCycle", plan.BillingCycle);
            p.Add("p_CustomMonths", plan.CustomMonths);
            p.Add("p_CreatedBy", createdBy);
            p.Add("o_PlanId", dbType: DbType.Int32, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("sp_SubscriptionPlan_Create", p, commandType: CommandType.StoredProcedure);
            return p.Get<int>("o_PlanId");
        }

        public async Task<bool> UpdatePlanAsync(SubscriptionPlanDbEntity plan, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            var p = new DynamicParameters();
            p.Add("p_PlanId", plan.PlanId);
            p.Add("p_PlanName", plan.PlanName);
            p.Add("p_Description", plan.Description);
            p.Add("p_Price", plan.Price);
            p.Add("p_BillingCycle", plan.BillingCycle);
            p.Add("p_CustomMonths", plan.CustomMonths);
            p.Add("p_ModifiedBy", modifiedBy);

            await conn.ExecuteAsync("sp_SubscriptionPlan_Update", p, commandType: CommandType.StoredProcedure);
            return true;
        }
        public async Task<bool> DeletePlanAsync(int planId, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync("sp_SubscriptionPlan_Delete",
                new { p_PlanId = planId, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return true;
        }
        public async Task<bool> UpdateTenantStatusAsync(int organizationId, string newStatus, int modifiedBy)
        {
            using var conn = _dbFactory.CreateConnection();
            await conn.ExecuteAsync("sp_Tenant_UpdateStatus",
                new { p_OrganizationId = organizationId, p_TenantStatus = newStatus, p_ModifiedBy = modifiedBy },
                commandType: CommandType.StoredProcedure);
            return true;
        }

        public async Task<SuperAdminAnalytics> GetAnalyticsAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstAsync<SuperAdminAnalytics>(
                "sp_SuperAdmin_Analytics_GetOverview",
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<PlanUsage>> GetPlanUsageAsync()
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryAsync<PlanUsage>(
                "SELECT * FROM vw_SubscriptionUsage");
        }

        public async Task<TenantDetail?> GetTenantDetailAsync(int organizationId)
        {
            using var conn = _dbFactory.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<TenantDetail>(
                "sp_Tenant_GetDetailById",
                new { p_OrganizationId = organizationId },
                commandType: CommandType.StoredProcedure);
        }
    }
}

