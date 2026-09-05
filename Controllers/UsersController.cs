using MaintenanceRequestSystem.DTOs.Users;
using MaintenanceRequestSystem.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MaintenanceRequestSystem.Controllers;

[Authorize(Roles = "Admin")]
[ApiExplorerSettings(IgnoreApi = true)]
public class UsersController : Controller
{
    private readonly IUserService _userService;

    public UsersController(IUserService userService)
    {
        _userService = userService;
    }

    public async Task<IActionResult> Index()
    {
        var users = await _userService.GetAllUsersAsync();
        return View(users);
    }

    public async Task<IActionResult> Details(string id)
    {
        var user = await _userService.GetUserByIdAsync(id);
        if (user == null) return NotFound();
        return View(user);
    }

    public async Task<IActionResult> Edit(string id)
    {
        var user = await _userService.GetUserByIdAsync(id);
        if (user == null) return NotFound();
        ViewBag.UserId = id;
        return View(new UpdateUserDto
        {
            FullName = user.FullName,
            Department = user.Department,
            PhoneNumber = user.PhoneNumber
        });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(string id, UpdateUserDto dto)
    {
        if (!ModelState.IsValid)
        {
            ViewBag.UserId = id;
            return View(dto);
        }
        var result = await _userService.UpdateUserAsync(id, dto);
        if (result == null) return NotFound();
        TempData["Success"] = "User updated!";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Activate(string id)
    {
        await _userService.ActivateUserAsync(id);
        TempData["Success"] = "User activated!";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Deactivate(string id)
    {
        await _userService.DeactivateUserAsync(id);
        TempData["Success"] = "User deactivated!";
        return RedirectToAction(nameof(Index));
    }
}
