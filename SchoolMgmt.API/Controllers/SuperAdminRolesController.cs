using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.DTOs.SuperAdmin;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/superadmin/roles")]
    [Authorize(Roles = "SuperAdmin")]
    public class SuperAdminRolesController : BaseController
    {
        private readonly ISuperAdminRoleService _service;

        public SuperAdminRolesController(ISuperAdminRoleService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _service.GetAllRolesAsync();
            return OkResponse(result, "Fetched all roles successfully.");
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateRoleRequest req)
        {
            var userId = GetCurrentUserId();
            var (success, msg) = await _service.CreateRoleAsync(req.RoleName, userId);
            return success ? OkResponse<object>(null, msg) : BadRequestResponse(msg);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] CreateRoleRequest req)
        {
            var userId = GetCurrentUserId();
            var (success, msg) = await _service.UpdateRoleAsync(id, req.RoleName, userId);
            return success ? OkResponse<object>(null, msg) : BadRequestResponse(msg);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> SoftDelete(int id)
        {
            var userId = GetCurrentUserId();
            var (success, msg) = await _service.SoftDeleteRoleAsync(id, userId);
            return success ? OkResponse<object>(null, msg) : BadRequestResponse(msg);
        }

        [HttpGet("{id}/permissions")]
        public async Task<IActionResult> GetPermissions(int id)
        {
            var result = await _service.GetRolePermissionsAsync(id);
            return OkResponse(result, "Fetched role permissions successfully.");
        }

        [HttpPost("assign-permission")]
        public async Task<IActionResult> AssignPermission([FromBody] RolePermissionUpdateDto req)
        {
            var userId = GetCurrentUserId();
            var (success, msg) = await _service.AssignPermissionAsync(req, userId);
            return success ? OkResponse<object>(null, msg) : BadRequestResponse(msg);
        }

        private int GetCurrentUserId()
        {
            var claim = User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub)
                        ?? User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);

            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
    }
}
