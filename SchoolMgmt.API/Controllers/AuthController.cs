using Azure.Core;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Application.DTOs.Auth;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Shared.Responses;


namespace SchoolMgmt.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : BaseController
    {
        private readonly IAuthService _authService;
        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        /// <summary>
        /// Tenant registration: creates Organization + initial Admin + subscription (atomic via SP)
        /// Public endpoint
        /// </summary>
        [HttpPost("register")]
        [AllowAnonymous]
        public async Task<IActionResult> Register([FromBody] RegisterRequest req)
        {
            if (!ModelState.IsValid)
                return BadRequestResponse("Invalid input data", "VALIDATION_ERROR");

            var (success, message, response) = await _authService.RegisterAsync(req);

            if (!success)
                return BadRequestResponse(message, "REGISTRATION_FAILED");

            return CreatedResponse(response, message ?? "Tenant registered successfully");
        }

        /// <summary>
        /// Login with username + password. Returns access token + refresh token.
        /// Public endpoint
        /// </summary>
        [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] LoginRequest req)
        {
            if (string.IsNullOrWhiteSpace(req.Username) || string.IsNullOrWhiteSpace(req.Password))
                return BadRequestResponse("Username and password are required", "VALIDATION_ERROR");

            var (success, message, response) = await _authService.LoginAsync(req);

            if (!success)
                return UnauthorizedResponse(message ?? "Invalid credentials", "LOGIN_FAILED");

            return OkResponse(response, message ?? "Login successful");
        }

        /// <summary>
        /// Refresh access token using refresh token (rotates tokens).
        /// Public endpoint (requires refresh token in body)
        /// </summary>
        [HttpPost("refresh")]
        [AllowAnonymous]
        public async Task<IActionResult> Refresh([FromBody] RefreshRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.RefreshToken))
                return BadRequestResponse("Refresh token is required", "VALIDATION_ERROR");

            var (success, message, response) = await _authService.RefreshAsync(request.RefreshToken);

            if (!success)
                return UnauthorizedResponse(message ?? "Invalid or expired refresh token", "TOKEN_INVALID");

            return OkResponse(response, message ?? "Token refreshed successfully");
        }

        /// <summary>
        /// Logout: revoke refresh token
        /// Requires authentication.
        /// </summary>
        [HttpPost("logout")]
        [Authorize]
        public async Task<IActionResult> Logout([FromBody] LogoutRequest req)
        {
            if (string.IsNullOrWhiteSpace(req.RefreshToken))
                return BadRequestResponse("Refresh token is required", "VALIDATION_ERROR");

            var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)
                              ?? User.FindFirst(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub);

            var performedBy = userIdClaim != null && int.TryParse(userIdClaim.Value, out var id) ? id : 0;

            await _authService.LogoutAsync(req.RefreshToken, performedBy);

            return OkResponse<object>(null, "Logged out successfully.");
        }
    }
}
