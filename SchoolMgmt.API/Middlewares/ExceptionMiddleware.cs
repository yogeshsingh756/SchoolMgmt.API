using SchoolMgmt.Shared.Responses;
using System.Net;
using System.Text.Json;

namespace SchoolMgmt.API.Middlewares
{
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ExceptionMiddleware> _logger;

        public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task Invoke(HttpContext ctx)
        {
            try
            {
                await _next(ctx);
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning(ex, "Unauthorized");
                await Write(ctx, HttpStatusCode.Unauthorized, ApiResponse<object?>.Fail(ex.Message, "UNAUTHORIZED"));
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "BadRequest");
                await Write(ctx, HttpStatusCode.BadRequest, ApiResponse<object?>.Fail(ex.Message, "BAD_REQUEST"));
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning(ex, "NotFound");
                await Write(ctx, HttpStatusCode.NotFound, ApiResponse<object?>.Fail(ex.Message, "NOT_FOUND"));
            }
            catch (JsonException ex)
            {
                _logger.LogWarning(ex, "Invalid JSON");
                await Write(ctx, HttpStatusCode.BadRequest, ApiResponse<object?>.Fail("Invalid JSON format.", "BAD_JSON"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unhandled");
                // Return real exception text so server/deploy issues are diagnosable (e.g. SP / DB / JWT).
                var detail = ex.InnerException != null
                    ? $"{ex.GetType().Name}: {ex.Message} | Inner: {ex.InnerException.Message}"
                    : $"{ex.GetType().Name}: {ex.Message}";
                await Write(ctx, HttpStatusCode.InternalServerError, ApiResponse<object?>.Fail(detail, "SERVER_ERROR"));
            }
        }

        private static async Task Write(HttpContext ctx, HttpStatusCode status, ApiResponse<object?> payload)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.StatusCode = (int)status;
            var json = JsonSerializer.Serialize(payload, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });
            await ctx.Response.WriteAsync(json);
        }
    }
}
