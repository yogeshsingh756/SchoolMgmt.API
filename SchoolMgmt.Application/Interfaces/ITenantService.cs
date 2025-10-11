using SchoolMgmt.Application.DTOs.Tenants;
using TenantDto = SchoolMgmt.Application.DTOs.Tenants.TenantDto;

namespace SchoolMgmt.Application.Interfaces
{
    public interface ITenantService
    {
        Task<TenantRegistrationResultDto> RegisterTenantAsync(TenantRegistrationRequestDto request);
        Task<IEnumerable<TenantDto>> GetAllTenantsAsync();
        Task<TenantDto?> GetTenantByIdAsync(int organizationId);
        Task<bool> UpdateTenantAsync(UpdateTenantDto request);
        Task<bool> DeleteTenantAsync(int organizationId);
        Task<bool> RenewSubscriptionAsync(int organizationId, int planId, bool isTrial, int? customMonths, int modifiedBy);
    }

}
