using SchoolMgmt.Application.DTOs.SuperAdmin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface ISuperAdminService
    {
        Task<IEnumerable<SubscriptionPlanDto>> GetAllPlansAsync();
        Task<int> CreatePlanAsync(SubscriptionPlanDto dto, int createdBy);
        Task<bool> UpdatePlanAsync(SubscriptionPlanDto dto, int modifiedBy);
        Task<bool> DeletePlanAsync(int planId, int modifiedBy);
        Task<bool> UpdateTenantStatusAsync(int organizationId, string newStatus, int modifiedBy);

        Task<SuperAdminAnalyticsDto> GetAnalyticsOverviewAsync();
        Task<IEnumerable<PlanUsageDto>> GetPlanUsageAsync();
        Task<TenantDetailDto?> GetTenantDetailAsync(int organizationId);
    }
}
