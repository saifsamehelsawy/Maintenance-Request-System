using MaintenanceRequestSystem.DTOs.Categories;
using MaintenanceRequestSystem.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MaintenanceRequestSystem.Controllers;

[Authorize(Roles = "Admin")]
[ApiExplorerSettings(IgnoreApi = true)]
public class CategoriesController : Controller
{
    private readonly ICategoryService _categoryService;

    public CategoriesController(ICategoryService categoryService)
    {
        _categoryService = categoryService;
    }

    public async Task<IActionResult> Index()
    {
        var categories = await _categoryService.GetAllCategoriesAsync(includeInactive: true);
        return View(categories);
    }

    public IActionResult Create() => View();

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(CreateCategoryDto dto)
    {
        if (!ModelState.IsValid) return View(dto);
        await _categoryService.CreateCategoryAsync(dto);
        TempData["Success"] = "Category created!";
        return RedirectToAction(nameof(Index));
    }

    public async Task<IActionResult> Edit(int id)
    {
        var category = await _categoryService.GetCategoryByIdAsync(id);
        if (category == null) return NotFound();
        ViewBag.CategoryId = id;
        return View(new UpdateCategoryDto
        {
            Name = category.Name,
            Description = category.Description,
            IsActive = category.IsActive
        });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, UpdateCategoryDto dto)
    {
        if (!ModelState.IsValid)
        {
            ViewBag.CategoryId = id;
            return View(dto);
        }
        var result = await _categoryService.UpdateCategoryAsync(id, dto);
        if (result == null) return NotFound();
        TempData["Success"] = "Category updated!";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _categoryService.DeleteCategoryAsync(id);
        TempData["Success"] = "Category deleted!";
        return RedirectToAction(nameof(Index));
    }
}
