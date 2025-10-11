using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Responses;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/superadmin")]
    [Authorize(Roles = "SuperAdmin")]
    public class SuperAdminController : BaseController
    {
        private readonly ISuperAdminService _superAdminService;
        private readonly ILogger<SuperAdminController> _logger;

        public SuperAdminController(ISuperAdminService superAdminService, ILogger<SuperAdminController> logger)
        {
            _superAdminService = superAdminService;
            _logger = logger;
        }

        // -----------------------------------------------
        //  SUBSCRIPTION PLAN MANAGEMENT
        // -----------------------------------------------

        /// <summary>
        /// Get all subscription plans.
        /// </summary>
        [HttpGet("subscription/plans")]
        public async Task<IActionResult> GetPlans()
        {
            var plans = await _superAdminService.GetAllPlansAsync();

            if (plans == null || !plans.Any())
                return NotFoundResponse("No subscription plans found.");

            return OkResponse(plans, "Fetched subscription plans successfully.");
        }

        /// <summary>
        /// Create a new subscription plan.
        /// </summary>
        [HttpPost("subscription/plans")]
        public async Task<IActionResult> CreatePlan([FromBody] SubscriptionPlanDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequestResponse("Invalid input data", "VALIDATION_ERROR");

            var createdBy = GetCurrentUserId();

            var planId = await _superAdminService.CreatePlanAsync(dto, createdBy);
            if (planId == null || planId <= 0)
                return ServerErrorResponse( "Failed to create subscription plan.", "CREATE_FAILED");

            return CreatedResponse(new { planId }, "Subscription plan created successfully.");
        }

        /// <summary>
        /// Update a subscription plan.
        /// </summary>
        [HttpPatch("subscription/plans/{id}")]
        public async Task<IActionResult> UpdatePlan(int id, [FromBody] SubscriptionPlanDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequestResponse("Invalid input data", "VALIDATION_ERROR");

            var modifiedBy = GetCurrentUserId();
            dto.PlanId = id;

            var success = await _superAdminService.UpdatePlanAsync(dto, modifiedBy);
            if (!success)
                return NotFoundResponse("Subscription plan not found.");

            return OkResponse<object>(null,"Subscription plan updated successfully.");
        }

        /// <summary>
        /// Delete (soft delete) a subscription plan.
        /// </summary>
        [HttpDelete("subscription/plans/{id}")]
        public async Task<IActionResult> DeletePlan(int id)
        {
            var modifiedBy = GetCurrentUserId();

            var success = await _superAdminService.DeletePlanAsync(id, modifiedBy);
            if (!success)
                return NotFoundResponse("Failed to delete subscription plan or plan not found.");

            return OkResponse<object>(null,"Subscription plan deleted successfully.");
        }

        // -----------------------------------------------
        //  TENANT MANAGEMENT
        // -----------------------------------------------

        /// <summary>
        /// Update tenant status (Active, Suspended, etc.)
        /// </summary>
        [HttpPatch("tenants/{id}/status")]
        public async Task<IActionResult> UpdateTenantStatus(int id, [FromBody] UpdateTenantStatusRequest req)
        {
            if (req == null || string.IsNullOrEmpty(req.NewStatus))
                return BadRequestResponse("Status value is required.", "VALIDATION_ERROR");

            var modifiedBy = GetCurrentUserId();
            var success = await _superAdminService.UpdateTenantStatusAsync(id, req.NewStatus, modifiedBy);

            if (!success)
                return NotFoundResponse("Failed to update tenant status or tenant not found.");

            return OkResponse<object>(null,"Tenant status updated successfully.");
        }

        [HttpGet("analytics/overview")]
        public async Task<IActionResult> GetAnalyticsOverview()
        {
            var result = await _superAdminService.GetAnalyticsOverviewAsync();
            return OkResponse(result, "Fetched platform analytics successfully.");
        }

        [HttpGet("subscription/usage")]
        public async Task<IActionResult> GetPlanUsage()
        {
            var result = await _superAdminService.GetPlanUsageAsync();
            return OkResponse(result, "Fetched subscription usage data successfully.");
        }

        [HttpGet("tenant/{organizationId}")]
        public async Task<IActionResult> GetTenantDetail(int organizationId)
        {
            var result = await _superAdminService.GetTenantDetailAsync(organizationId);
            if (result == null)
                return NotFoundResponse("Tenant not found.");

            return OkResponse(result, "Fetched tenant details successfully.");
        }

        // -----------------------------------------------
        //  COMMON HELPERS
        // -----------------------------------------------
        private int GetCurrentUserId()
        {
            var claim = User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub)
                        ?? User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);

            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
    }
}
