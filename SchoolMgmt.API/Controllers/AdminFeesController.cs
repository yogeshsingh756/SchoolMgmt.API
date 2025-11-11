using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Application.Services;
using SchoolMgmt.Shared.Interfaces;
using SchoolMgmt.Shared.Models.Fee;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/fees")]
    [Authorize]
    public class AdminFeesController : BaseController
    {
        private readonly IFeeBillingRepository _svc;
        private readonly IFeeMasterService _feeMasterService;
        private readonly IClassSectionService _service;
        public AdminFeesController(IFeeBillingRepository svc,IFeeMasterService feeMasterService,IClassSectionService service)
        {
            _feeMasterService = feeMasterService;
            _svc = svc;
            _service = service;
        }

        // DROPDOWNS: fee types, terms, sessions, classes
        [HttpGet("dropdowns")]
        public async Task<IActionResult> GetDropdowns()
        {
            var orgId = GetOrgIdFromClaims();
            var classes = await _service.GetAllClassesAsync(orgId);
            var feeTypes = await _feeMasterService.GetFeeTypesAsync(orgId);
            var terms = await _feeMasterService.GetTermsAsync(orgId);
            var sessions = await _feeMasterService.GetSessionsAsync(orgId);
            return OkResponse(new { feeTypes, terms, sessions, classes }, "Fetched all master data successfully.");
        }

        // CLASS FEE MASTER
        [HttpGet("class-fees")]
        public async Task<IActionResult> GetClassFees([FromQuery] int page = 1, [FromQuery] int size = 10, [FromQuery] string? search = null)
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _svc.GetClassFeeMasterAsync(orgId, page, size, search);
            return OkResponse(result, "Fetched class fee master.");
        }

        [HttpPost("class-fees")]
        public async Task<IActionResult> UpsertClassFee([FromBody] ClassFeeMaster dto)
        {
            var userId = GetCurrentUserId();
            var id = await _svc.UpsertClassFeeAsync(dto, userId);
            return OkResponse(new { classFeeId = id }, "Saved class fee.");
        }

        [HttpDelete("class-fees/{classFeeId}")]
        public async Task<IActionResult> DeleteClassFee(int classFeeId)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            await _svc.DeleteClassFeeAsync(orgId, classFeeId, userId);
            return OkResponse("Deleted.");
        }

        // CONCESSIONS
        [HttpGet("concessions/{studentId}")]
        public async Task<IActionResult> GetConcessions(int studentId)
        {
            var orgId = GetOrgIdFromClaims();
            var list = await _svc.GetConcessionsAsync(orgId, studentId);
            return OkResponse(list, "Fetched concessions.");
        }

        [HttpPost("concessions")]
        public async Task<IActionResult> UpsertConcession([FromBody] ConcessionUpsert dto)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var id = await _svc.UpsertConcessionAsync(orgId, dto, userId);
            return OkResponse(new { concessionId = id }, "Saved concession.");
        }

        // INVOICES
        [HttpPost("invoices/generate")]
        public async Task<IActionResult> GenerateInvoice([FromBody] InvoiceGenerateRequest req)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var result = await _svc.GenerateInvoiceAsync(orgId, req, userId);
            return OkResponse(result, "Invoice generated.");
        }

        [HttpGet("invoices")]
        public async Task<IActionResult> GetInvoices([FromQuery] int page = 1, [FromQuery] int size = 10, [FromQuery] string? search = null)
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _svc.GetInvoicesAsync(orgId, page, size, search);
            return OkResponse(result, "Fetched invoices.");
        }

        [HttpGet("invoices/{invoiceId}")]
        public async Task<IActionResult> GetInvoiceById(int invoiceId)
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _svc.GetInvoiceByIdAsync(orgId, invoiceId);

            var response = new
            {
                Header = result.header,
                Items = result.items,
                Allocations = result.allocations
            };

            return OkResponse(response, "Fetched invoice successfully.");
        }

        // PAYMENTS
        [HttpPost("payments")]
        public async Task<IActionResult> CreatePayment([FromBody] PaymentCreateRequest req)
        {
            var orgId = GetOrgIdFromClaims();
            var userId = GetCurrentUserId();
            var result = await _svc.CreatePaymentAsync(orgId, req, userId);
            return OkResponse(result, "Payment created & allocated.");
        }

        [HttpGet("students")]
        public async Task<IActionResult> GetAllStudents(int page = 1, int pageSize = 10, string search = "")
        {
            var orgId = GetOrgIdFromClaims();
            var response = await _svc.GetAllStudentsAsync(orgId, page, pageSize, search);
            return OkResponse(response, "Student Fetched Successfully");
        }
        [HttpGet("payments")]
        public async Task<IActionResult> GetPayments([FromQuery] int page = 1, [FromQuery] int size = 10, [FromQuery] string? search = null)
        {
            var orgId = GetOrgIdFromClaims();
            var result = await _svc.GetPaymentsAsync(orgId, page, size, search);
            return OkResponse(result, "Fetched payments.");
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
