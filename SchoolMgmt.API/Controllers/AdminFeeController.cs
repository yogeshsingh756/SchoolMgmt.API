using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Models.Fee;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/fees")]
    [Authorize]
    public class AdminFeeController : BaseController
    {
        private readonly IFeeService _feeService;

        public AdminFeeController(IFeeService feeService)
        {
            _feeService = feeService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllFees()
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _feeService.GetAllFeesAsync(orgId);
            return OkResponse(result, "Fetched all fees successfully.");
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetFeeById(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _feeService.GetFeeByIdAsync(id, orgId);
            return OkResponse(result, "Fetched fee details successfully.");
        }

        [HttpPost]
        public async Task<IActionResult> UpsertFee([FromBody] FeeDto dto)
        {
            var modifiedBy = GetCurrentUserId();
            var success = await _feeService.UpsertFeeAsync(dto, modifiedBy);
            return success ? OkResponse("Fee saved successfully.") : FailResponse("Failed to save fee.");
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFee(int id)
        {
            var orgId = GetOrgIdFromClaims();
            var modifiedBy = GetCurrentUserId();
            var success = await _feeService.DeleteFeeAsync(id, orgId, modifiedBy);
            return success ? OkResponse("Fee deleted successfully.") : FailResponse("Failed to delete fee.");
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
