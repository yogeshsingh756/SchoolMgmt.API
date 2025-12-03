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
        private readonly ISuperAdminService _superAdminService;
        public AuthController(IAuthService authService, ISuperAdminService superAdminService)
        {
            _authService = authService;
            _superAdminService = superAdminService;
        }

        // ------------------------------------------------------
        // 🔹 GET /api/register/plans
        // Public endpoint - fetches available subscription plans
        // ------------------------------------------------------
        [HttpGet("subscription/plans")]
        public async Task<IActionResult> GetPlans()
        {
            var plans = await _superAdminService.GetAllPlansAsync();

            if (plans == null || !plans.Any())
                return NotFoundResponse("No subscription plans found.");

            return OkResponse(plans, "Fetched subscription plans successfully.");
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

        // 1) Verify username
        [HttpPost("verify-username")]
        [AllowAnonymous] // or require Admin depending on flow
        public async Task<IActionResult> VerifyUsername([FromBody] VerifyUsernameRequestDto req)
        {
            if (string.IsNullOrWhiteSpace(req.UsernameOrEmail))
                return BadRequestResponse("Username or email is required.");

            var user = await _authService.VerifyUsernameAsync(req.UsernameOrEmail);
            if (user == null)
                return NotFoundResponse("User not found.");

            // return minimal info. Avoid returning any sensitive field.
            return OkResponse(user, "User found.");
        }

        // 2) Change password
        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequestDto req)
        {
            if (req == null || req.UserId <= 0 || string.IsNullOrWhiteSpace(req.NewPassword))
                return BadRequestResponse("Invalid request.");

            var (success, msg) = await _authService.ChangePasswordAsync(req);

            return success ? OkResponse<object>(null, msg) : FailResponse(msg);
        }
    }
}
