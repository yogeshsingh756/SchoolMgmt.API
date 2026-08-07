using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Models.Admin;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/admission-prefixes")]
    [Authorize]
    public class AdminAdmissionPrefixController : BaseController
    {
        private readonly IAdminService _adminService;

        public AdminAdmissionPrefixController(IAdminService adminService)
        {
            _adminService = adminService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var orgId = GetOrgIdFromClaims();
            var list = await _adminService.GetAdmissionPrefixesAsync(orgId);
            return OkResponse(list, "Fetched admission prefixes.");
        }

        [HttpPost]
        public async Task<IActionResult> Upsert([FromBody] AdmissionNoPrefixUpsertRequest req)
        {
            if (req == null || req.ClassId <= 0 || string.IsNullOrWhiteSpace(req.Prefix))
                return BadRequestResponse("Class and prefix are required.");

            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var (success, newId, message) = await _adminService.UpsertAdmissionPrefixAsync(orgId, req, userId);
            return success
                ? OkResponse(new { id = newId }, message)
                : FailResponse(message);
        }

        [HttpDelete("{prefixId:int}")]
        public async Task<IActionResult> Delete(int prefixId)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var (success, message) = await _adminService.DeleteAdmissionPrefixAsync(orgId, prefixId, userId);
            return success ? OkResponse(message) : FailResponse(message);
        }

        /// <summary>
        /// Allocates the next admission number for a class (increments sequence).
        /// </summary>
        [HttpGet("next")]
        public async Task<IActionResult> Next([FromQuery] int classId)
        {
            if (classId <= 0)
                return BadRequestResponse("classId is required.");

            var orgId = GetOrgIdFromClaims();
            var (success, admissionNo, message) = await _adminService.AllocateNextAdmissionNoAsync(orgId, classId);
            return success
                ? OkResponse(new { admissionNo }, message)
                : FailResponse(message);
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
