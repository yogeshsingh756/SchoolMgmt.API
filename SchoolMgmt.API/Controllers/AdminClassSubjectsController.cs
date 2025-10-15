using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/classes/{classId}/subjects")]
    [Authorize(Roles = "Admin")]
    public class AdminClassSubjectsController : BaseController
    {
        private readonly IClassSubjectService _service;

        public AdminClassSubjectsController(IClassSubjectService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetByClass(int classId)
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _service.GetByClassAsync(orgId, classId);
            return OkResponse(result, "Fetched subjects for class successfully.");
        }

        [HttpPost("{subjectId}")]
        public async Task<IActionResult> AssignSubject(int classId, int subjectId)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var id = await _service.AssignSubjectAsync(orgId, classId, subjectId, userId);
            return OkResponse(new { ClassSubjectId = id }, "Subject assigned successfully.");
        }

        [HttpDelete("{classSubjectId}")]
        public async Task<IActionResult> RemoveSubject(int classId, int classSubjectId)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var success = await _service.RemoveSubjectAsync(orgId, classSubjectId, userId);
            return success ? OkResponse("Removed successfully.") : FailResponse("Delete failed.");
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
