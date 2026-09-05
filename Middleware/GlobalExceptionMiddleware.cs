using System.Net;
using System.Text.Json;
using MaintenanceRequestSystem.DTOs.Common;

namespace MaintenanceRequestSystem.Middleware;

public class GlobalExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionMiddleware> _logger;
    private readonly IHostEnvironment _env;

    public GlobalExceptionMiddleware(RequestDelegate next,
        ILogger<GlobalExceptionMiddleware> logger,
        IHostEnvironment env)
    {
        _next = next;
        _logger = logger;
        _env = env;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception: {Message}", ex.Message);
            await HandleExceptionAsync(context, ex);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        // Only handle API routes with JSON response
        if (context.Request.Path.StartsWithSegments("/api"))
        {
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

            var response = ApiResponse.ErrorResponse(
                _env.IsDevelopment()
                    ? exception.Message
                    : "An internal server error occurred. Please try again later."
            );

            var json = JsonSerializer.Serialize(response, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            await context.Response.WriteAsync(json);
        }
        else
        {
            // For MVC routes, redirect to error page safely
            if (!context.Response.HasStarted)
            {
                if (context.Request.Path.StartsWithSegments("/Home/Error"))
                {
                    context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                    await context.Response.WriteAsync("A critical error occurred. Please contact the administrator.");
                }
                else
                {
                    context.Response.Redirect("/Home/Error");
                }
            }
        }
    }
}
