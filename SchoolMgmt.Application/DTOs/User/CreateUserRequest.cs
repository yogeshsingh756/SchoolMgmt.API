using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.User
{
    public class CreateUserRequest
    {

        [Required]
        public string RoleName { get; set; } = string.Empty;

        [Required, StringLength(100)]
        public string FirstName { get; set; } = string.Empty;

        [StringLength(100)]
        public string? LastName { get; set; }

        [Required, StringLength(50)]
        public string Username { get; set; } = string.Empty;

        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required, StringLength(20, MinimumLength = 6)]
        public string Password { get; set; } = string.Empty;

        [Phone]
        public string? PhoneNumber { get; set; }

        // 🧑‍🏫 Optional Teacher fields
        public string? Qualification { get; set; }
        public string? Designation { get; set; }
        public decimal? Salary { get; set; }

        // 👨‍👩‍👧 Optional Parent fields
        public string? Occupation { get; set; }
        public string? Address { get; set; }

        // 🎓 Optional Student fields
        public string? AdmissionNo { get; set; }
        public int? ParentId { get; set; }
        public int? ClassId { get; set; }
    }
}
