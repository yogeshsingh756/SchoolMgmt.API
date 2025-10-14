using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.DTOs.Admin;
using SchoolMgmt.Application.DTOs.User;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Responses;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin")]
    [Authorize(Roles = "Admin")]
    public class AdminController : BaseController
    {
        private readonly IAdminService _adminService;
        private readonly ITenantService _tenantService;
        private readonly ILogger<AdminController> _logger;

        public AdminController(IAdminService adminService, ITenantService tenantService, ILogger<AdminController> logger)
        {
            _adminService = adminService;
            _tenantService = tenantService;
            _logger = logger;
        }

        // -----------------------------------------------
        // 📦 SUBSCRIPTION MANAGEMENT (Tenant Admin)
        // -----------------------------------------------

        /// <summary>
        /// Get the current tenant's subscription details.
        /// </summary>
        [HttpGet("subscription/current")]
        public async Task<IActionResult> GetCurrentSubscription()
        {
            var orgId = GetOrgIdFromClaims();
            if (orgId == 0)
                return BadRequestResponse("Invalid organization context.", "INVALID_ORG");

            var result = await _tenantService.GetTenantByIdAsync(orgId);
            if (result == null)
                return NotFoundResponse("Subscription details not found.");

            return OkResponse(result, "Fetched current subscription details successfully.");
        }

        /// <summary>
        /// Renew or change tenant subscription plan.
        /// </summary>
        [HttpPost("subscription/renew")]
        public async Task<IActionResult> RenewSubscription([FromBody] RenewSubscriptionRequest req)
        {
            if (!ModelState.IsValid)
                return BadRequestResponse("Invalid subscription renewal request.", "VALIDATION_ERROR");

            var orgId = GetOrgIdFromClaims();
            if (orgId == 0)
                return BadRequestResponse("Invalid organization context.", "INVALID_ORG");

            var success = await _tenantService.RenewSubscriptionAsync(orgId, req.PlanId, req.IsTrial, req.CustomMonths, GetCurrentUserId());

            if (!success)
                return ServerErrorResponse("Failed to renew subscription.", "RENEWAL_FAILED");

            return OkResponse<object>(null, "Subscription renewed successfully.");
        }

        // -----------------------------------------------
        // 👥 USER MANAGEMENT (Tenant-level Admin)
        // -----------------------------------------------

        /// <summary>
        /// Add a tenant-level user (Teacher/Student/Parent).
        /// </summary>
        [HttpPost("users")]
        public async Task<IActionResult> CreateUser([FromBody] CreateUserRequest req)
        {
            if (!ModelState.IsValid)
                return BadRequestResponse("Invalid user creation request.", "VALIDATION_ERROR");

            var orgId = GetOrgIdFromClaims();
            if (orgId == 0)
                return BadRequestResponse("Invalid organization context.", "INVALID_ORG");

            var createdBy = GetCurrentUserId();
            var (success, msg) = await _adminService.CreateUserAsync(orgId, req, createdBy);

            if (!success)
                return ServerErrorResponse(msg ?? "Failed to create user.", "CREATE_USER_FAILED");

            return CreatedResponse<object>(null, msg ?? "User created successfully.");
        }

        [HttpGet("dashboard/overview")]
        public async Task<IActionResult> GetDashboardOverview()
        {
            var orgId = GetOrgIdFromClaims();
            if (orgId == 0)
                return BadRequestResponse("Invalid organization context.");

            var result = await _adminService.GetDashboardAsync(orgId);
            return OkResponse(result, "Fetched admin dashboard overview successfully.");
        }

        /// <summary>
        /// Update tenant-level user details.
        /// </summary>
        [HttpPut("users")]
        public async Task<IActionResult> UpdateUser([FromBody] UpdateUserRequest req)
        {
            if (!ModelState.IsValid)
                return BadRequestResponse("Invalid user update request.", "VALIDATION_ERROR");

            var orgId = GetOrgIdFromClaims();
            if (orgId == 0)
                return BadRequestResponse("Invalid organization context.", "INVALID_ORG");

            var modifiedBy = GetCurrentUserId();
            var (success, msg) = await _adminService.UpdateUserAsync(orgId, req, modifiedBy);

            if (!success)
                return ServerErrorResponse(msg ?? "Failed to update user.", "UPDATE_USER_FAILED");

            return OkResponse(msg ?? "User updated successfully.");
        }

        /// <summary>
        /// Soft delete a tenant-level user.
        /// </summary>
        [HttpDelete("users/{userId}")]
        public async Task<IActionResult> SoftDeleteUser(int userId)
        {
            var orgId = GetOrgIdFromClaims();
            if (orgId == 0)
                return BadRequestResponse("Invalid organization context.", "INVALID_ORG");

            var modifiedBy = GetCurrentUserId();
            var (success, msg) = await _adminService.SoftDeleteUserAsync(orgId, userId, modifiedBy);

            if (!success)
                return ServerErrorResponse(msg ?? "Failed to delete user.", "DELETE_USER_FAILED");

            return OkResponse(msg ?? "User deleted successfully.");
        }
        // -----------------------------------------------
        // 🔐 HELPERS
        // -----------------------------------------------
        private int GetOrgIdFromClaims()
        {
            var claim = User.FindFirst("org");
            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }

        private int GetCurrentUserId()
        {
            var claim = User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub)
                        ?? User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);

            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }

        /// <summary>
        /// Get all tenant users with pagination, search, and status filter.
        /// </summary>
        [HttpGet("users")]
        public async Task<IActionResult> GetAllUsers([FromQuery] GetUsersRequest req)
        {
            var orgId = GetOrgIdFromClaims();
            if (orgId == 0)
                return BadRequestResponse("Invalid organization context.", "INVALID_ORG");

            var result = await _adminService.GetAllUsersAsync(orgId, req);

            if (!result.Users.Any())
                return NotFoundResponse("No users found for the current organization.");

            return OkResponse(result, "Fetched users successfully.");
        }

        [HttpGet("roles/available")]
        public async Task<IActionResult> GetAssignableRoles()
        {
            var adminId = GetCurrentUserId();
            var roles = await _adminService.GetAssignableRolesForAdminAsync(adminId);
            return OkResponse(roles, "Fetched Role details successfully.");
        }
    }

}
