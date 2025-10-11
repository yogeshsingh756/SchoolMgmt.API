using Dapper;
using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Shared.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Services
{
    public class SuperAdminService : ISuperAdminService
    {
        private readonly SuperAdminRepository _repo;
        public SuperAdminService( SuperAdminRepository repo)
        {
            _repo = repo;
        }

        public async Task<IEnumerable<SubscriptionPlanDto>> GetAllPlansAsync()
        {
            var entities = await _repo.GetAllPlansAsync();
            return entities.Select(p => new SubscriptionPlanDto
            {
                PlanId = p.PlanId,
                PlanName = p.PlanName,
                Description = p.Description,
                Price = p.Price,
                BillingCycle = p.BillingCycle,
                CustomMonths = p.CustomMonths,
                IsActive = p.IsActive
            });
        }

        public async Task<int> CreatePlanAsync(SubscriptionPlanDto dto, int createdBy)
        {
            var entity = new SubscriptionPlanDbEntity
            {
                PlanName = dto.PlanName,
                Description = dto.Description,
                Price = dto.Price,
                BillingCycle = dto.BillingCycle,
                CustomMonths = dto.CustomMonths
            };
            return await _repo.CreatePlanAsync(entity, createdBy);
        }

        public async Task<bool> UpdatePlanAsync(SubscriptionPlanDto dto, int modifiedBy)
        {
            var entity = new SubscriptionPlanDbEntity
            {
                PlanId = dto.PlanId,
                PlanName = dto.PlanName,
                Description = dto.Description,
                Price = dto.Price,
                BillingCycle = dto.BillingCycle,
                CustomMonths = dto.CustomMonths
            };
            return await _repo.UpdatePlanAsync(entity, modifiedBy);
        }

        public async Task<bool> DeletePlanAsync(int planId, int modifiedBy)
           => await _repo.DeletePlanAsync(planId, modifiedBy);
        public async Task<bool> UpdateTenantStatusAsync(int organizationId, string newStatus, int modifiedBy)
            => await _repo.UpdateTenantStatusAsync(organizationId, newStatus, modifiedBy);

        public async Task<SuperAdminAnalyticsDto> GetAnalyticsOverviewAsync()
        {
            var data = await _repo.GetAnalyticsAsync();
            return new SuperAdminAnalyticsDto
            {
                TotalTenants = data.TotalTenants,
                ActiveTenants = data.ActiveTenants,
                InactiveTenants = data.InactiveTenants,
                TotalUsers = data.TotalUsers,
                ActiveSubscriptions = data.ActiveSubscriptions,
                ExpiredSubscriptions = data.ExpiredSubscriptions
            };
        }

        public async Task<IEnumerable<PlanUsageDto>> GetPlanUsageAsync()
        {
            var list = await _repo.GetPlanUsageAsync();
            return list.Select(x => new PlanUsageDto
            {
                PlanId = x.PlanId,
                PlanName = x.PlanName,
                TenantCount = x.TenantCount,
                ActiveTenants = x.ActiveTenants
            });
        }

        public async Task<TenantDetailDto?> GetTenantDetailAsync(int organizationId)
        {
            var entity = await _repo.GetTenantDetailAsync(organizationId);
            if (entity == null) return null;

            return new TenantDetailDto
            {
                OrganizationId = entity.OrganizationId,
                SchoolName = entity.SchoolName,
                Email = entity.Email,
                Phone = entity.Phone,
                PlanName = entity.PlanName,
                StartedAt = entity.StartedAt,
                ExpiresAt = entity.ExpiresAt,
                SubscriptionStatus = entity.SubscriptionStatus,
                IsActive = entity.IsActive,
                UserCount = entity.UserCount
            };
        }
    }
}
