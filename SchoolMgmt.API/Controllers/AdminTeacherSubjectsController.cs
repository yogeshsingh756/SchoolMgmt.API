using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/teachers/{teacherId}/subjects")]
    [Authorize(Roles = "Admin")]
    public class AdminTeacherSubjectsController : BaseController
    {
        private readonly ITeacherSubjectService _service;

        public AdminTeacherSubjectsController(ITeacherSubjectService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetByTeacher(int teacherId)
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _service.GetByTeacherAsync(orgId, teacherId);
            return OkResponse(result, "Fetched teacher subjects successfully.");
        }

        [HttpPost]
        public async Task<IActionResult> AssignSubject(int teacherId, [FromBody] dynamic body)
        {
            int classId = (int)body.classId;
            int? sectionId = (int?)body.sectionId;
            int subjectId = (int)body.subjectId;
            bool isPrimary = body.isPrimary;
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();

            var id = await _service.AssignAsync(orgId, teacherId, classId, sectionId, subjectId, isPrimary, userId);
            return OkResponse(new { TeacherSubjectId = id }, "Teacher assigned successfully.");
        }

        [HttpDelete("{teacherSubjectId}")]
        public async Task<IActionResult> Unassign(int teacherId, int teacherSubjectId)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var success = await _service.UnassignAsync(orgId, teacherSubjectId, userId);
            return success ? OkResponse("Unassigned successfully.") : FailResponse("Operation failed.");
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
