using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.DTOs.Admin;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Application.Services;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/classes")]
    [Authorize(Roles = "Admin")]
    public class AdminClassesController : BaseController
    {
        private readonly IClassSectionService _service;

        public AdminClassesController(IClassSectionService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            int orgId = GetOrgIdFromClaims();
            var result = await _service.GetAllClassesAsync(orgId);
            return OkResponse(result, "Fetched classes successfully.");
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] ClassDto dto)
        {
            int orgId = GetOrgIdFromClaims();
            int userId = GetCurrentUserId();
            var (id, msg) = await _service.CreateClassAsync(dto, orgId, userId);
            return CreatedResponse(new { id }, msg);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] ClassDto dto)
        {
            int orgId = GetOrgIdFromClaims();
            int userId = GetCurrentUserId();
            dto.ClassId = id;
            var (success, msg) = await _service.UpdateClassAsync(dto, orgId, userId);
            return success ? OkResponse(msg) : FailResponse(msg);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            int orgId = GetOrgIdFromClaims();
            int userId = GetCurrentUserId();
            var (success, msg) = await _service.DeleteClassAsync(id, orgId, userId);
            return success ? OkResponse(msg) : FailResponse(msg);
        }

        [HttpGet("{classId}/sections")]
        public async Task<IActionResult> GetSections(int classId)
        {
            int orgId = GetOrgIdFromClaims();
            var result = await _service.GetSectionsByClassAsync(orgId, classId, false);
            return OkResponse(result, "Fetched sections.");
        }

        [HttpPost("{classId}/sections")]
        public async Task<IActionResult> CreateSection(int classId, [FromBody] SectionDto dto)
        {
            int orgId = GetOrgIdFromClaims();
            int userId = GetCurrentUserId();
            dto.ClassId = classId;
            var (id, msg) = await _service.CreateSectionAsync(dto, orgId, userId);
            return CreatedResponse(new { id }, msg);
        }

        [HttpPut("sections/{id}")]
        public async Task<IActionResult> UpdateSection(int id, [FromBody] SectionDto dto)
        {
            int orgId = GetOrgIdFromClaims();
            int userId = GetCurrentUserId();
            dto.SectionId = id;
            var (success, msg) = await _service.UpdateSectionAsync(dto, orgId, userId);
            return success ? OkResponse(msg) : FailResponse(msg);
        }

        [HttpDelete("sections/{id}")]
        public async Task<IActionResult> DeleteSection(int id)
        {
            int orgId = GetOrgIdFromClaims();
            int userId = GetCurrentUserId();
            var (success, msg) = await _service.DeleteSectionAsync(id, orgId, userId);
            return success ? OkResponse(msg) : FailResponse(msg);
        }

        [HttpGet("teachers")]
        public async Task<IActionResult> GetTeachersByOrganization()
        {
            int orgId = GetOrgIdFromClaims();
            var result = await _service.GetTeachersByOrganizationAsync(orgId);
            return OkResponse(result, "Fetched teachers successfully.");
        }
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
    }
}
