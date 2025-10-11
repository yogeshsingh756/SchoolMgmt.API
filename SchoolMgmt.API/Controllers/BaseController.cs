using Microsoft.AspNetCore.Mvc;
using SchoolMgmt.Shared.Responses;
using System.Net;

namespace SchoolMgmt.API.Controllers
{
      /// <summary>
     /// Base controller providing unified response structure and proper HTTP codes.
     /// </summary>
        [ApiController]
        public abstract class BaseController : ControllerBase
        {
        // ✅ OK (200) — success with optional data
        protected IActionResult OkResponse<T>(T data, string message = "Success")
        {
            return Ok(ApiResponse<T>.Ok(data, message));
        }

        // ✅ Overload: OK (200) — message only (no data)
        protected IActionResult OkResponse(string message = "Success")
        {
            return Ok(ApiResponse<object>.Ok(null, message));
        }

        // ✅ Created (201)
        protected IActionResult CreatedResponse<T>(T data, string message = "Created successfully")
        {
            return StatusCode(StatusCodes.Status201Created, ApiResponse<T>.Ok(data, message));
        }

        // ✅ Bad Request (400)
        protected IActionResult BadRequestResponse(string message, string code = "BAD_REQUEST")
        {
            return BadRequest(ApiResponse<object>.Fail(message, code));
        }

        // ✅ Unauthorized (401)
        protected IActionResult UnauthorizedResponse(string message = "Unauthorized", string code = "UNAUTHORIZED")
        {
            return StatusCode(StatusCodes.Status401Unauthorized, ApiResponse<object>.Fail(message, code));
        }

        // ✅ Forbidden (403)
        protected IActionResult ForbiddenResponse(string message = "Forbidden", string code = "FORBIDDEN")
        {
            return StatusCode(StatusCodes.Status403Forbidden, ApiResponse<object>.Fail(message, code));
        }

        // ✅ Not Found (404)
        protected IActionResult NotFoundResponse(string message = "Not found", string code = "NOT_FOUND")
        {
            return NotFound(ApiResponse<object>.Fail(message, code));
        }

        // ✅ Server Error (500)
        protected IActionResult ServerErrorResponse(string message, string code = "SERVER_ERROR")
        {
            return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.Fail(message, code));
        }

        // ✅ Validation Error (422)
        protected IActionResult ValidationResponse(string message, string code = "VALIDATION_ERROR")
        {
            return StatusCode(StatusCodes.Status422UnprocessableEntity, ApiResponse<object>.Fail(message, code));
        }

        // ✅ Fail (general fallback)
        protected IActionResult FailResponse(string message, string code = "FAILED")
        {
            return StatusCode(StatusCodes.Status400BadRequest, ApiResponse<object>.Fail(message, code));
        }

        /// 📑 Paginated 200 OK
        protected IActionResult PaginatedResponse<T>(
                IEnumerable<T> data, int totalCount, int pageNumber, int pageSize,
                string message = "Success")
            {
                var payload = new
                {
                    items = data,
                    pagination = new
                    {
                        totalCount,
                        pageNumber,
                        pageSize,
                        totalPages = (int)Math.Ceiling((double)totalCount / pageSize)
                    }
                };

                return StatusCode((int)HttpStatusCode.OK, ApiResponse<object>.Ok(payload, message));
            }
        protected IActionResult FailResponse(string message)
        {
            return Ok(ApiResponse<object?>.Fail(message, "FAILED"));
        }
    }
    }

