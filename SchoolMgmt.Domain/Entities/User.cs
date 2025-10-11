using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Domain.Entities
{
    public class User
    {
        public int UserId { get; set; }
        public int OrganizationId { get; set; }
        public int? RoleId { get; set; }
        public string? RoleName { get; set; } // optional, often joined
        public string FirstName { get; set; } = string.Empty;
        public string? LastName { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public bool IsActive { get; set; } = true;
        public bool IsDeleted { get; set; } = false;
        public DateTime CreatedOn { get; set; } = DateTime.UtcNow;
        public int? ModifiedBy { get; set; }
        public int? CreatedBy { get; set; }
    }
}
