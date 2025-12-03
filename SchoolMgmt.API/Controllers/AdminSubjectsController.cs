using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Models.Subject;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/subjects")]
    [Authorize]
    public class AdminSubjectsController : BaseController
    {
        private readonly ISubjectService _service;

        public AdminSubjectsController(ISubjectService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetSubjects([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10)
        {
            var organizationId = GetOrgIdFromClaims();
            var result = await _service.GetSubjectsAsync(organizationId, pageNumber, pageSize);
            return OkResponse(result, "Fetched subjects successfully.");
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetSubject(int id)
        {
            var organizationId = GetOrgIdFromClaims();
            var subject = await _service.GetSubjectByIdAsync(organizationId, id);
            if (subject == null)
                return NotFoundResponse("Subject not found.");
            return OkResponse(subject, "Fetched subject successfully.");
        }

        [HttpPost]
        public async Task<IActionResult> CreateSubject([FromBody] SubjectDto dto)
        {
            var organizationId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var newId = await _service.CreateSubjectAsync(organizationId, dto, userId);
            return OkResponse(new { SubjectId = newId }, "Subject created successfully.");
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateSubject(int id, [FromBody] SubjectDto dto)
        {
            dto.SubjectId = id;
            var organizationId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var success = await _service.UpdateSubjectAsync(organizationId, dto, userId);
            return success ? OkResponse("Subject updated successfully.") : FailResponse("Update failed.");
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSubject(int id)
        {
            var organizationId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var success = await _service.DeleteSubjectAsync(organizationId, id, userId);
            return success ? OkResponse("Subject deleted successfully.") : FailResponse("Delete failed.");
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
