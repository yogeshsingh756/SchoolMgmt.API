using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/feemasters")]
    [Authorize(Roles = "Admin")]
    public class AdminFeeMasterController : BaseController
    {
        private readonly IFeeMasterService _feeMasterService;

        public AdminFeeMasterController(IFeeMasterService feeMasterService)
        {
            _feeMasterService = feeMasterService;
        }

        [HttpGet("dropdowns")]
        public async Task<IActionResult> GetDropdownMasters()
        {
            var orgId = GetOrgIdFromClaims();

            var feeTypes = await _feeMasterService.GetFeeTypesAsync(orgId);
            var terms = await _feeMasterService.GetTermsAsync(orgId);
            var sessions = await _feeMasterService.GetSessionsAsync(orgId);

            return OkResponse(new { feeTypes, terms, sessions }, "Fetched all master data successfully.");
        }

        [HttpPost("feetype")]
        public async Task<IActionResult> UpsertFeeType([FromBody] FeeTypeEntity entity)
        {
            var userId = GetCurrentUserId();
            var success = await _feeMasterService.UpsertFeeTypeAsync(entity, userId);
            return success ? OkResponse("Fee Type saved successfully.") : FailResponse("Failed to save Fee Type.");
        }

        [HttpPost("term")]
        public async Task<IActionResult> UpsertTerm([FromBody] AcademicTermEntity entity)
        {
            var userId = GetCurrentUserId();
            var success = await _feeMasterService.UpsertTermAsync(entity, userId);
            return success ? OkResponse("Term saved successfully.") : FailResponse("Failed to save Term.");
        }

        [HttpPost("session")]
        public async Task<IActionResult> UpsertSession([FromBody] AcademicSessionEntity entity)
        {
            var userId = GetCurrentUserId();
            var success = await _feeMasterService.UpsertSessionAsync(entity, userId);
            return success ? OkResponse("Session saved successfully.") : FailResponse("Failed to save Session.");
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
