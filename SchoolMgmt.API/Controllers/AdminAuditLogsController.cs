using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/admin/auditlogs")]
    [Authorize(Roles = "Admin")]
    public class AdminAuditLogsController : BaseController
    {
        private readonly IAuditLogService _service;

        public AdminAuditLogsController(IAuditLogService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string? search)
        {
            int orgId = GetOrgIdFromClaims();
            var result = await _service.GetAllAsync(orgId, search);
            return OkResponse(result, "Fetched organization audit logs.");
        }

        private int GetOrgIdFromClaims()
        {
            var claim = User.FindFirst("org");
            return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
        }
    }
}
