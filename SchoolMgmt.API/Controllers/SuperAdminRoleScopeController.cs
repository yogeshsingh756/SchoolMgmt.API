using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/superadmin/role-scope")]
    [Authorize(Roles = "SuperAdmin")]
    public class SuperAdminRoleScopeController : BaseController
    {
        private readonly IRoleService _roleService;
        public SuperAdminRoleScopeController(IRoleService roleService)
        {
            _roleService = roleService;
        }

        // 🟩 Get all roles assignable for an admin
        [HttpGet("{adminUserId}")]
        public async Task<IActionResult> GetRoleScope(int adminUserId)
        {
            var result = await _roleService.GetAssignableRolesByAdminAsync(adminUserId);
            return OkResponse(result, "Fetched allowed roles for admin.");
        }

        // 🟨 Save role scope (used when SuperAdmin toggles role checkboxes)
        [HttpPost("{adminUserId}")]
        public async Task<IActionResult> UpdateRoleScope(int adminUserId, [FromBody] List<int> allowedRoleIds)
        {
            var createdBy = GetCurrentUserId();
            var success = await _roleService.UpsertRoleScopeAsync(adminUserId, allowedRoleIds, createdBy);

            return success
                ? OkResponse("Role scope updated successfully.")
                : ServerErrorResponse("Failed to update role scope.");
        }

        private int GetCurrentUserId()
        {
            var claim = User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub)
                        ?? User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);

            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
    }
}
