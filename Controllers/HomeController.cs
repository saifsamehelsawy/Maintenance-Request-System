using MaintenanceRequestSystem.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace MaintenanceRequestSystem.Controllers;

[ApiExplorerSettings(IgnoreApi = true)]
public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        if (User.Identity?.IsAuthenticated == true)
        {
            _logger.LogInformation("Authenticated user accessed HomeController.");
            return RedirectToAction("Index", "Dashboard");
        }

        _logger.LogInformation("Unauthenticated user redirected to Login.");
        return RedirectToAction("Login", "Account");
    }

    public IActionResult Privacy() => View();

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel
        {
            RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier
        });
    }
}