using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using SchoolMgmt.API.Middlewares;
using SchoolMgmt.Application.Interfaces;
using SchoolMgmt.Application.Services;
using SchoolMgmt.Infrastructure.Data;
using SchoolMgmt.Infrastructure.Repositories;
using SchoolMgmt.Infrastructure.Services;
using SchoolMgmt.Shared.Interfaces;
using System.Text;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// fix for render
builder.WebHost.ConfigureKestrel(serverOptions =>
{
    var port = Environment.GetEnvironmentVariable("PORT") ?? "10000";
    serverOptions.ListenAnyIP(int.Parse(port));
});
// fix for render close

// Add DbContext
//var connStr = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddControllers()
    .AddJsonOptions(o => o.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull);
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "SchoolMgmt API",
        Version = "v1",
        Description = "Multi-tenant School Management API"
    });

    // 🔑 Add JWT Bearer auth definition
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Enter: **Bearer {your token}**"
    });

    // 🔑 Make Swagger use that auth definition globally
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// Connection + Infra
builder.Services.AddSingleton<IDbConnectionFactory, DbConnectionFactory>();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<ISuperAdminService, SuperAdminService>();
builder.Services.AddScoped<IJwtTokenService, JwtTokenService>();
builder.Services.AddScoped<ITenantService, TenantService>();
builder.Services.AddScoped<IAdminService, AdminService>();
builder.Services.AddScoped<IPermissionService, PermissionRepository>();
builder.Services.AddScoped<ISuperAdminRoleService, SuperAdminRoleService>();
builder.Services.AddScoped<IRoleService, RoleService>();
builder.Services.AddScoped<IModuleService, ModuleService>();
builder.Services.AddScoped<IAuditLogService, AuditLogService>();
builder.Services.AddScoped<IAuditLogRepository, AuditLogRepository>();
builder.Services.AddScoped<IClassSectionService, ClassSectionService>();
builder.Services.AddScoped<ISubjectService, SubjectService>();
builder.Services.AddScoped<IClassSubjectService, ClassSubjectService>();
builder.Services.AddScoped<ITeacherSubjectService, TeacherSubjectService>();
builder.Services.AddScoped<IFeeService, FeeService>();
builder.Services.AddScoped<IFeeMasterService, FeeMasterService>();
builder.Services.AddScoped<IFeeBillingRepository, FeeBillingRepository>();
builder.Services.AddScoped<IPaymentMethodService, PaymentMethodService>();
builder.Services.AddScoped<IFeeReportService, FeeReportService>();
builder.Services.AddScoped<FeeReportsRepository>();
builder.Services.AddScoped<PaymentMethodRepository>();
builder.Services.AddScoped<FeeMasterRepository>();
builder.Services.AddScoped<FeeRepository>();
builder.Services.AddScoped<SubjectRepository>();
builder.Services.AddScoped<ClassSectionRepository>();
builder.Services.AddScoped<SuperAdminRoleRepository>();
builder.Services.AddScoped<AdminRepository>();
builder.Services.AddScoped<SuperAdminRepository>();
builder.Services.AddScoped<ModuleRepository>();
builder.Services.AddScoped<RoleRepository>();
builder.Services.AddScoped<ClassSubjectRepository>();
builder.Services.AddScoped<TeacherSubjectRepository>();



// JWT
var key = builder.Configuration["Jwt:Key"]!;
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new()
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key))
        };
    });
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .WithOrigins(
                "https://sfms.abhiworld.in",   
                "http://localhost:3000",      
                "http://localhost:5173",
                "http://localhost:5174",
                "https://erp.kpmic.in"
            )
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials();  // only if you send cookies/auth headers
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
//{
// Middlewares order
app.UseMiddleware<ExceptionMiddleware>(); // always first

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "SchoolMgmt API v1");
    c.RoutePrefix = "swagger";
});

app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseMiddleware<TenantResolverMiddleware>(); // tenant resolver
app.UseAuthorization();

app.MapControllers();

app.Run();
