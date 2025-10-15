using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Audit
{
    public class AuditLogCreateDto
    {
        public int? OrganizationId { get; set; }
        public int? UserId { get; set; }
        public string? EntityName { get; set; }
        public string? ActionType { get; set; }
        public string? EntityKey { get; set; }
        public string? Description { get; set; }
        public string? OldValue { get; set; }
        public string? NewValue { get; set; }
        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }
    }
}
