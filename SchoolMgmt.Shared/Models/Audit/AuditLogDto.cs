using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Shared.Models.Audit
{
    public class AuditLogDto
    {
        public int AuditLogId { get; set; }
        public int? OrganizationId { get; set; }
        public string? OrganizationName { get; set; }
        public int? UserId { get; set; }
        public string? PerformedBy { get; set; }
        public string? EntityName { get; set; }
        public string? ActionType { get; set; }
        public string? Description { get; set; }
        public DateTime CreatedOn { get; set; }
        public string? IpAddress { get; set; }
    }
}
