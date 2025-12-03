using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Domain.Entities;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/feemasters")]
    [Authorize]
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

        // ===== Fee Types =====
        [HttpGet("feetype")]
        public async Task<IActionResult> GetFeeTypes()
        {
            var orgId = GetOrgIdFromClaims();
            var list = await _feeMasterService.GetFeeTypesAsync(orgId);
            return OkResponse(list, "Fetched fee types.");
        }

        [HttpGet("feetype/{id:int}")]
        public async Task<IActionResult> GetFeeType(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var item = await _feeMasterService.GetFeeTypeByIdAsync(id, orgId);
            return item is null ? NotFoundResponse("Fee type not found.") : OkResponse(item, "Fetched fee type.");
        }

        [HttpPost("feetype")]
        public async Task<IActionResult> UpsertFeeType([FromBody] FeeTypeEntity entity)
        {
            entity.OrganizationId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var id = await _feeMasterService.UpsertFeeTypeAsync(entity, userId);
            return OkResponse(new { id }, entity.FeeTypeId == 0 ? "Fee type created." : "Fee type updated.");
        }

        [HttpDelete("feetype/{id:int}")]
        public async Task<IActionResult> DeleteFeeType(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var ok = await _feeMasterService.DeleteFeeTypeAsync(id, orgId, userId);
            return ok ? OkResponse("Fee type deleted.") : FailResponse("Delete failed.");
        }

        // ===== Terms =====
        [HttpGet("term")]
        public async Task<IActionResult> GetTerms()
        {
            var orgId = GetOrgIdFromClaims();
            var list = await _feeMasterService.GetTermsAsync(orgId);
            return OkResponse(list, "Fetched terms.");
        }

        [HttpGet("term/{id:int}")]
        public async Task<IActionResult> GetTerm(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var item = await _feeMasterService.GetTermByIdAsync(id, orgId);
            return item is null ? NotFoundResponse("Term not found.") : OkResponse(item, "Fetched term.");
        }

        [HttpPost("term")]
        public async Task<IActionResult> UpsertTerm([FromBody] AcademicTermEntity entity)
        {
            entity.OrganizationId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var id = await _feeMasterService.UpsertTermAsync(entity, userId);
            return OkResponse(new { id }, entity.TermId == 0 ? "Term created." : "Term updated.");
        }

        [HttpDelete("term/{id:int}")]
        public async Task<IActionResult> DeleteTerm(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var ok = await _feeMasterService.DeleteTermAsync(id, orgId, userId);
            return ok ? OkResponse("Term deleted.") : FailResponse("Delete failed.");
        }

        // ===== Sessions =====
        [HttpGet("session")]
        public async Task<IActionResult> GetSessions()
        {
            var orgId = GetOrgIdFromClaims();
            var list = await _feeMasterService.GetSessionsAsync(orgId);
            return OkResponse(list, "Fetched sessions.");
        }

        [HttpGet("session/{id:int}")]
        public async Task<IActionResult> GetSession(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var item = await _feeMasterService.GetSessionByIdAsync(id, orgId);
            return item is null ? NotFoundResponse("Session not found.") : OkResponse(item, "Fetched session.");
        }

        [HttpPost("session")]
        public async Task<IActionResult> UpsertSession([FromBody] AcademicSessionEntity entity)
        {
            entity.OrganizationId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var id = await _feeMasterService.UpsertSessionAsync(entity, userId);
            return OkResponse(new { id }, entity.SessionId == 0 ? "Session created." : "Session updated.");
        }

        [HttpDelete("session/{id:int}")]
        public async Task<IActionResult> DeleteSession(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var ok = await _feeMasterService.DeleteSessionAsync(id, orgId, userId);
            return ok ? OkResponse("Session deleted.") : FailResponse("Delete failed.");
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
