using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Auth
{
    public class RegisterRequest
    {
        public string SchoolName { get; set; } = string.Empty;
        public string? Address { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }
        public int? PlanId { get; set; }
        public bool IsTrial { get; set; }
        public int TrialDays { get; set; } = 0;

        // Admin user
        public string AdminFirstName { get; set; } = string.Empty;
        public string? AdminLastName { get; set; }
        public string AdminUsername { get; set; } = string.Empty;
        public string AdminEmail { get; set; } = string.Empty;
        public string AdminPassword { get; set; } = string.Empty;
        public string AdminPhone { get; set; } = string.Empty;
    }
}
