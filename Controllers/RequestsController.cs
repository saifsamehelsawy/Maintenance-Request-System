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
    private readonly ILogger<RequestsController> _logger;

    public RequestsController(
        IRequestService requestService,
        ICategoryService categoryService,
        IUserService userService,
        ILogger<RequestsController> logger)
    {
        _requestService = requestService;
        _categoryService = categoryService;
        _userService = userService;
        _logger = logger;
    }

    public async Task<IActionResult> Index([FromQuery] RequestFilterDto filter)
    {
        var (userId, userRole) = GetUserContext();

        _logger.LogInformation(
            "Loading maintenance requests for user {UserId} with role {UserRole}.",
            userId,
            userRole);

        var result = await _requestService.GetRequestsAsync(filter, userId, userRole);

        ViewBag.Filter = filter;
        ViewBag.Categories = await _categoryService.GetAllCategoriesAsync();

        return View(result);
    }

    public async Task<IActionResult> Details(int id)
    {
        var (userId, userRole) = GetUserContext();

        if (!await _requestService.RequestExistsAsync(id))
        {
            _logger.LogWarning(
                "Maintenance request {RequestId} was not found.",
                id);

            return NotFound();
        }

        var request = await _requestService.GetRequestByIdAsync(id, userId, userRole);

        if (request == null)
        {
            _logger.LogWarning(
                "User {UserId} was denied access to request {RequestId}.",
                userId,
                id);

            return Forbid();
        }

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
            await _categoryService.GetAllCategoriesAsync(),
            "Id",
            "Name");

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
                await _categoryService.GetAllCategoriesAsync(),
                "Id",
                "Name");

            return View(dto);
        }

        var userId = GetUserId();
        var result = await _requestService.CreateRequestAsync(dto, userId);

        _logger.LogInformation(
            "Maintenance request {RequestNumber} was created by user {UserId}.",
            result.RequestNumber,
            userId);

        TempData["Success"] =
            $"Request {result.RequestNumber} created successfully!";

        return RedirectToAction(nameof(Details), new { id = result.Id });
    }

    public async Task<IActionResult> Edit(int id)
    {
        var (userId, userRole) = GetUserContext();

        if (!await _requestService.RequestExistsAsync(id))
            return NotFound();

        var request =
            await _requestService.GetRequestByIdAsync(id, userId, userRole);

        if (request == null)
            return Forbid();

        if (userRole == "Employee" && request.Status != "Pending")
        {
            TempData["Error"] =
                "You can only edit requests with Pending status.";

            return RedirectToAction(nameof(Details), new { id });
        }

        ViewBag.Categories = new SelectList(
            await _categoryService.GetAllCategoriesAsync(),
            "Id",
            "Name",
            request.Category.Id);

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
                await _categoryService.GetAllCategoriesAsync(),
                "Id",
                "Name");

            ViewBag.RequestId = id;

            return View(dto);
        }

        var (userId, userRole) = GetUserContext();

        var result =
            await _requestService.UpdateRequestAsync(
                id,
                dto,
                userId,
                userRole);

        if (result == null)
        {
            _logger.LogWarning(
                "User {UserId} was not allowed to update request {RequestId}.",
                userId,
                id);

            TempData["Error"] = "Update not allowed.";

            return RedirectToAction(nameof(Details), new { id });
        }

        _logger.LogInformation(
            "Request {RequestId} was updated by user {UserId}.",
            id,
            userId);

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

        _logger.LogInformation(
            "Request {RequestId} was assigned to a technician by admin {AdminId}.",
            id,
            adminId);

        TempData["Success"] = "Technician assigned successfully!";

        return RedirectToAction(nameof(Details), new { id });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [Authorize(Roles = "Technician,Admin")]
    public async Task<IActionResult> ChangeStatus(
        int id,
        ChangeRequestStatusDto dto)
    {
        var (userId, userRole) = GetUserContext();

        var result =
            await _requestService.ChangeStatusAsync(
                id,
                dto,
                userId,
                userRole);

        if (result == null)
        {
            _logger.LogWarning(
                "User {UserId} was not allowed to change status for request {RequestId}.",
                userId,
                id);

            TempData["Error"] = "Status change not allowed.";
        }
        else
        {
            _logger.LogInformation(
                "Request {RequestId} status changed to {Status} by user {UserId}.",
                id,
                dto.Status,
                userId);

            TempData["Success"] = $"Status changed to {dto.Status}";
        }

        return RedirectToAction(nameof(Details), new { id });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> AddComment(
        int id,
        AddCommentDto dto)
    {
        var (userId, userRole) = GetUserContext();

        await _requestService.AddCommentAsync(
            id,
            dto,
            userId,
            userRole);

        _logger.LogInformation(
            "User {UserId} added a comment to request {RequestId}.",
            userId,
            id);

        TempData["Success"] = "Comment added!";

        return RedirectToAction(nameof(Details), new { id });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var (userId, userRole) = GetUserContext();

        var success =
            await _requestService.DeleteRequestAsync(
                id,
                userId,
                userRole);

        if (success)
        {
            _logger.LogInformation(
                "Request {RequestId} was deleted by user {UserId}.",
                id,
                userId);

            TempData["Success"] = "Request deleted successfully!";
        }
        else
        {
            _logger.LogWarning(
                "User {UserId} was not allowed to delete request {RequestId}.",
                userId,
                id);

            TempData["Error"] = "Cannot delete this request.";
        }

        return RedirectToAction(nameof(Index));
    }

    private string GetUserId() =>
        User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? string.Empty;

    private string GetUserRole()
    {
        if (User.IsInRole("Admin"))
            return "Admin";

        if (User.IsInRole("Technician"))
            return "Technician";

        return "Employee";
    }

    private (string userId, string userRole) GetUserContext() =>
        (GetUserId(), GetUserRole());
}