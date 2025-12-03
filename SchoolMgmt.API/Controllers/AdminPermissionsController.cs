using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Permission;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/permissions")]
    [Authorize]
    public class AdminPermissionsController : BaseController
    {
        private readonly IPermissionService _permissionService;
        public AdminPermissionsController(IPermissionService permissionService)
        {
            _permissionService = permissionService;
        }

        /// <summary>
        /// Gets the list of all permissions for a specific user,
        /// showing current access (CanView, CanEdit, etc.).
        /// Used by Admin UI to manage permission toggles.
        /// </summary>
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserPermissions(int userId)
        {
            var adminId = GetCurrentUserId();

            if (userId <= 0)
                return BadRequestResponse("Invalid user ID.");

            var result = await _permissionService.GetUserPermissionsAsync(userId, adminId);

            if (result == null || !result.Any())
                return NotFoundResponse("No permissions found for this user.");

            return OkResponse(result, "Fetched user permissions successfully.");
        }

        /// <summary>
        /// Updates user-specific permissions (overrides role permissions).
        /// Called when Admin saves the permission toggle grid.
        /// </summary>
        [HttpPost("user/{userId}")]
        public async Task<IActionResult> UpdateUserPermissions(int userId, [FromBody] List<UserPermissionDtoV2> permissions)
        {
            if (userId <= 0)
                return BadRequestResponse("Invalid user ID.");

            if (permissions == null || permissions.Count == 0)
                return BadRequestResponse("No permissions provided.");

            var modifiedBy = GetCurrentUserId();
            var success = await _permissionService.UpsertUserPermissionsAsync(userId, permissions, modifiedBy);

            return success
                ? OkResponse("User permissions updated successfully.")
                : FailResponse("Failed to update user permissions.");
        }

        /// <summary>
        /// Gets the merged (effective) permissions for a user.
        /// Combines role + user overrides — used by runtime authorization middleware.
        /// </summary>
        [HttpGet("user/{userId}/effective")]
        public async Task<IActionResult> GetEffectivePermissions(int userId)
        {
            if (userId <= 0)
                return BadRequestResponse("Invalid user ID.");

            var result = await _permissionService.GetEffectivePermissionsV2Async(userId);

            if (result == null || !result.Any())
                return NotFoundResponse("No effective permissions found.");

            return OkResponse(result, "Fetched effective permissions successfully.");
        }

        // 🔹 Utility method to safely get the current user ID from JWT claims
        private int GetCurrentUserId()
        {
            var claim = User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub)
                        ?? User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
    }
}
