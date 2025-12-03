using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.DTOs.Auth
{
    public class LogoutRequest { public string RefreshToken { get; set; } = string.Empty; }
    public class VerifyUsernameRequestDto
    {
        public string UsernameOrEmail { get; set; } = string.Empty;
    }

    public class VerifyUsernameResponseDto
    {
        public int UserId { get; set; }
        public int OrganizationId { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public bool IsActive { get; set; }
    }

    public class ChangePasswordRequestDto
    {
        public int UserId { get; set; }                // from verify response or admin selection
        public string NewPassword { get; set; } = "";  // plain text (will be hashed server-side)
    }

    public class ChangePasswordResponseDto
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
    }
}
