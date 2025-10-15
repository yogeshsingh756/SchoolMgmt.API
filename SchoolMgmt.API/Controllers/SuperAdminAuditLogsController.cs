using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.Interfaces;

namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/superadmin/auditlogs")]
    [Authorize(Roles = "SuperAdmin")]
    public class SuperAdminAuditLogsController : BaseController
    {
        private readonly IAuditLogService _service;

        public SuperAdminAuditLogsController(IAuditLogService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] int? organizationId, [FromQuery] string? search)
        {
            var result = await _service.GetAllAsync(organizationId, search);
            return OkResponse(result, "Fetched audit logs successfully.");
        }
    }
}
