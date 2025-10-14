using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.DTOs.Module;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/superadmin/modules")]
    [Authorize(Roles = "SuperAdmin")]
    public class SuperAdminModulesController : BaseController
    {
        private readonly IModuleService _service;
        private readonly ILogger<SuperAdminModulesController> _logger;

        public SuperAdminModulesController(IModuleService service, ILogger<SuperAdminModulesController> logger)
        {
            _service = service;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var modules = await _service.GetAllModulesAsync();
            return OkResponse(modules, "Fetched modules.");
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] ModuleDto dto)
        {
            if (!ModelState.IsValid) return BadRequestResponse("Invalid payload", "VALIDATION_ERROR");
            var createdBy = GetCurrentUserId();
            var (moduleId, success, message) = await _service.CreateModuleAsync(dto, createdBy);
            if (!success) return ServerErrorResponse(message ?? "Failed to create module.", "CREATE_FAILED");
            return CreatedResponse(new { moduleId }, message);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] ModuleDto dto)
        {
            var modifiedBy = GetCurrentUserId();
            var (success, message) = await _service.UpdateModuleAsync(id, dto, modifiedBy);
            return success ? OkResponse<object>(null, message ?? "Updated") : ServerErrorResponse(message ?? "Failed to update.");
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var modifiedBy = GetCurrentUserId();
            var (success, message) = await _service.DeleteModuleAsync(id, modifiedBy);
            return success ? OkResponse<object>(null, message ?? "Deleted") : ServerErrorResponse(message ?? "Failed to delete.");
        }

        // Submodules
        [HttpGet("{id}/submodules")]
        public async Task<IActionResult> GetSubModules(int id)
        {
            var list = await _service.GetSubModulesByModuleAsync(id);
            return OkResponse(list, "Fetched submodules.");
        }

        [HttpPost("submodules")]
        public async Task<IActionResult> CreateSubModule([FromBody] SubModuleDto dto)
        {
            if (!ModelState.IsValid) return BadRequestResponse("Invalid payload", "VALIDATION_ERROR");
            var createdBy = GetCurrentUserId();
            var (subModuleId, success, message) = await _service.CreateSubModuleAsync(dto, createdBy);
            if (!success) return ServerErrorResponse(message ?? "Failed to create submodule.");
            return CreatedResponse(new { subModuleId }, message);
        }

        [HttpPut("submodules/{id}")]
        public async Task<IActionResult> UpdateSubModule(int id, [FromBody] SubModuleDto dto)
        {
            var modifiedBy = GetCurrentUserId();
            var (success, message) = await _service.UpdateSubModuleAsync(id, dto, modifiedBy);
            return success ? OkResponse<object>(null, message) : ServerErrorResponse(message ?? "Failed to update submodule.");
        }

        [HttpDelete("submodules/{id}")]
        public async Task<IActionResult> DeleteSubModule(int id)
        {
            var modifiedBy = GetCurrentUserId();
            var (success, message) = await _service.DeleteSubModuleAsync(id, modifiedBy);
            return success ? OkResponse<object>(null, message) : ServerErrorResponse(message ?? "Failed to delete submodule.");
        }

        private int GetCurrentUserId()
        {
            var claim = User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub)
                        ?? User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
    }
}
