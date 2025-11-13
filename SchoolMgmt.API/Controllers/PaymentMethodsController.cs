using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.DTOs.PaymentMethod;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class PaymentMethodsController : BaseController
    {
        private readonly IPaymentMethodService _paymentService;

        public PaymentMethodsController(IPaymentMethodService paymentService)
        {
            _paymentService = paymentService;
        }

        [HttpPost("methods/upsert")]
        public async Task<IActionResult> UpsertMethod([FromBody] PaymentMethodUpsertDto model)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();

            model.OrganizationId = orgId;

            var success = await _paymentService.UpsertMethodAsync(model, userId);
            return success ? OkResponse("Payment method saved.")
                           : FailResponse("Failed to save payment method.");
        }

        [HttpGet("methods")]
        public async Task<IActionResult> GetMethods()
        {
            var orgId = GetOrgIdFromClaims();
            var data = await _paymentService.GetMethodsAsync(orgId);
            return OkResponse(data, "Fetched payment methods.");
        }

        [HttpGet("methods/{type}")]
        public async Task<IActionResult> GetMethodByType(string type)
        {
            var orgId = GetOrgIdFromClaims();
            var data = await _paymentService.GetByTypeAsync(orgId, type);

            if (data == null)
                return FailResponse("Payment method not found.");

            return OkResponse(data, "Fetched payment method.");
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
