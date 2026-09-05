using MaintenanceRequestSystem.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace MaintenanceRequestSystem.Controllers;

[Authorize]
[ApiExplorerSettings(IgnoreApi = true)]
public class DashboardController : Controller
{
    private readonly IDashboardService _dashboardService;

    public DashboardController(IDashboardService dashboardService)
    {
        _dashboardService = dashboardService;
    }

    [HttpGet]
    public async Task<IActionResult> Index()
    {
        var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? string.Empty;

        if (User.IsInRole("Admin"))
        {
            var data = await _dashboardService.GetAdminDashboardAsync();
            return View("AdminDashboard", data);
        }
        else if (User.IsInRole("Technician"))
        {
            var data = await _dashboardService.GetTechnicianDashboardAsync(userId);
            return View("TechnicianDashboard", data);
        }
        else
        {
            var data = await _dashboardService.GetEmployeeDashboardAsync(userId);
            return View("EmployeeDashboard", data);
        }
    }
}
