using MaintenanceRequestSystem.DTOs.Requests;
using MaintenanceRequestSystem.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Security.Claims;

namespace MaintenanceRequestSystem.Controllers;

[Authorize]
[ApiExplorerSettings(IgnoreApi = true)]
public class RequestsController : Controller
{
    private readonly IRequestService _requestService;
    private readonly ICategoryService _categoryService;
    private readonly IUserService _userService;

    public RequestsController(IRequestService requestService,
        ICategoryService categoryService, IUserService userService)
    {
        _requestService = requestService;
        _categoryService = categoryService;
        _userService = userService;
    }

    public async Task<IActionResult> Index([FromQuery] RequestFilterDto filter)
    {
        var (userId, userRole) = GetUserContext();
        var result = await _requestService.GetRequestsAsync(filter, userId, userRole);
        ViewBag.Filter = filter;
        ViewBag.Categories = await _categoryService.GetAllCategoriesAsync();
        return View(result);
    }

    public async Task<IActionResult> Details(int id)
    {
        var (userId, userRole) = GetUserContext();
        if (!await _requestService.RequestExistsAsync(id))
            return NotFound();

        var request = await _requestService.GetRequestByIdAsync(id, userId, userRole);
        if (request == null) return Forbid();

        if (User.IsInRole("Admin"))
        {
            ViewBag.Technicians = await _userService.GetTechniciansAsync();
        }

        return View(request);
    }

    [Authorize(Roles = "Employee")]
    public async Task<IActionResult> Create()
    {
        ViewBag.Categories = new SelectList(
            await _categoryService.GetAllCategoriesAsync(), "Id", "Name");
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles = "Employee")]
    public async Task<IActionResult> Create(CreateRequestDto dto)
    {
        if (!ModelState.IsValid)
        {
            ViewBag.Categories = new SelectList(
                await _categoryService.GetAllCategoriesAsync(), "Id", "Name");
            return View(dto);
        }

        var userId = GetUserId();
        var result = await _requestService.CreateRequestAsync(dto, userId);
        TempData["Success"] = $"Request {result.RequestNumber} created successfully!";
        return RedirectToAction(nameof(Details), new { id = result.Id });
    }

    public async Task<IActionResult> Edit(int id)
    {
        var (userId, userRole) = GetUserContext();
        if (!await _requestService.RequestExistsAsync(id))
            return NotFound();

        var request = await _requestService.GetRequestByIdAsync(id, userId, userRole);
        if (request == null) return Forbid();

        if (userRole == "Employee" && request.Status != "Pending")
        {
            TempData["Error"] = "You can only edit requests with Pending status.";
            return RedirectToAction(nameof(Details), new { id });
        }

        ViewBag.Categories = new SelectList(
            await _categoryService.GetAllCategoriesAsync(), "Id", "Name", request.Category.Id);
        ViewBag.RequestId = id;

        return View(new UpdateRequestDto
        {
            Title = request.Title,
            Description = request.Description,
            CategoryId = request.Category.Id,
            Priority = Enum.Parse<Models.Enums.Priority>(request.Priority)
        });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, UpdateRequestDto dto)
    {
        if (!ModelState.IsValid)
        {
            ViewBag.Categories = new SelectList(
                await _categoryService.GetAllCategoriesAsync(), "Id", "Name");
            ViewBag.RequestId = id;
            return View(dto);
        }

        var (userId, userRole) = GetUserContext();
        var result = await _requestService.UpdateRequestAsync(id, dto, userId, userRole);
        if (result == null)
        {
            TempData["Error"] = "Update not allowed.";
            return RedirectToAction(nameof(Details), new { id });
        }

        TempData["Success"] = "Request updated successfully!";
        return RedirectToAction(nameof(Details), new { id });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Assign(int id, AssignTechnicianDto dto)
    {
        var adminId = GetUserId();
        await _requestService.AssignTechnicianAsync(id, dto, adminId);
        TempData["Success"] = "Technician assigned successfully!";
        return RedirectToAction(nameof(Details), new { id });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles = "Technician,Admin")]
    public async Task<IActionResult> ChangeStatus(int id, ChangeRequestStatusDto dto)
    {
        var (userId, userRole) = GetUserContext();
        var result = await _requestService.ChangeStatusAsync(id, dto, userId, userRole);

        if (result == null)
            TempData["Error"] = "Status change not allowed.";
        else
            TempData["Success"] = $"Status changed to {dto.Status}";

        return RedirectToAction(nameof(Details), new { id });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> AddComment(int id, AddCommentDto dto)
    {
        var (userId, userRole) = GetUserContext();
        await _requestService.AddCommentAsync(id, dto, userId, userRole);
        TempData["Success"] = "Comment added!";
        return RedirectToAction(nameof(Details), new { id });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var (userId, userRole) = GetUserContext();
        var success = await _requestService.DeleteRequestAsync(id, userId, userRole);
        if (success)
            TempData["Success"] = "Request deleted successfully!";
        else
            TempData["Error"] = "Cannot delete this request.";

        return RedirectToAction(nameof(Index));
    }

    private string GetUserId() =>
        User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? string.Empty;

    private string GetUserRole()
    {
        if (User.IsInRole("Admin")) return "Admin";
        if (User.IsInRole("Technician")) return "Technician";
        return "Employee";
    }

    private (string userId, string userRole) GetUserContext() =>
        (GetUserId(), GetUserRole());
}
