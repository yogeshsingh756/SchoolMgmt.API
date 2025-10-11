using SchoolMgmt.Application.DTOs.Auth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolMgmt.Application.Interfaces
{
    public interface IAuthService
    {
        Task<(bool Success, string? Message, AuthResponse? Response)> RegisterAsync(RegisterRequest req);
        Task<(bool Success, string? Message, AuthResponse? Response)> LoginAsync(LoginRequest req);
        Task<(bool Success, string? Message, AuthResponse? Response)> RefreshAsync(string refreshToken);
        Task<bool> LogoutAsync(string refreshToken, int performedByUserId);
    }
}
