using SchoolMgmt.Shared.Constants;

namespace SchoolMgmt.API.Middlewares
{
    public class TenantResolverMiddleware
    {
        private readonly RequestDelegate _next;
        public TenantResolverMiddleware(RequestDelegate next) => _next = next;

        public async Task InvokeAsync(HttpContext context)
        {
            // Try to get 'org' claim from validated JWT
            var orgClaim = context.User?.Claims.FirstOrDefault(c => c.Type == "org")?.Value;
            if (!string.IsNullOrEmpty(orgClaim) && int.TryParse(orgClaim, out var orgId))
            {
                context.Items["OrganizationId"] = orgId;
            }

            await _next(context);
        }
    }

    // Extension for easier registration
    public static class TenantResolverMiddlewareExtensions
    {
        public static IApplicationBuilder UseTenantResolver(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<TenantResolverMiddleware>();
        }
    }
}
