# Blazor CSS Isolation Setup Guide (.NET 9)

## What is CSS Isolation?

CSS isolation allows you to scope CSS styles to specific Blazor components, preventing style conflicts and creating cleaner, more maintainable code.

### Without CSS Isolation

```css
/* Global styles - affects entire application */
.button { background: red; }
.version-info { color: white; }
```

### With CSS Isolation

```css
/* Component-scoped styles - only affects specific component */
.button[b-abc123] { background: red; }
.version-info[b-xyz789] { color: white; }
```

## Why CSS Isolation is Important

1. **Prevents Style Conflicts** - Component styles don't leak to other components
2. **Better Maintainability** - Each component manages its own styles
3. **Cleaner Architecture** - Styles are co-located with components
4. **Automatic Scoping** - Blazor handles the scoping attributes automatically

## The .NET 9 Problem

In .NET 9, CSS isolation has a **known issue**:

- **Development mode**: Works correctly (generates hashed CSS files)
- **Publish mode**: Fails to generate proper CSS isolation bundles
- **Result**: Deployed applications lose component-specific styling

## Required Setup

### 1. Project Configuration (Required)

Add to your `.csproj` or `Directory.Build.props`:

```xml
<PropertyGroup>
  <!-- Fix CSS isolation bundling in publish mode -->
  <StaticWebAssetBasePath>$(StaticWebAssetBasePath)</StaticWebAssetBasePath>
  
  <!-- Optional: Enable compression for better performance -->
  <BlazorEnableCompression>true</BlazorEnableCompression>
  <BlazorCacheBootResources>true</BlazorCacheBootResources>
</PropertyGroup>
```

### 2. Program.cs Configuration (Best Practice)

```csharp
var app = builder.Build();

// Configure static files properly
app.UseStaticFiles();        // Basic wwwroot files
app.MapStaticAssets();       // Modern static assets + CSS isolation

// Rest of your pipeline...
app.Run();
```

### 3. Component CSS Files

Create CSS files alongside your components:

```
MyComponent.razor       <- Component
MyComponent.razor.css   <- Component-specific styles
```

## Verification

### Test Local Publish

```bash
dotnet publish -c Release
```

**Check output**: Should contain CSS file with isolation attributes like:

```css
.my-class[b-abc123def] { /* styles */ }
```

### Test Deployment

- Component styles should work in deployed version
- No style conflicts between components
- Compressed CSS files (.br/.gz) for better performance

## Common Issues

| Issue                        | Cause                            | Solution                                            |
| ---------------------------- | -------------------------------- | --------------------------------------------------- |
| Styles missing in production | Missing `StaticWebAssetBasePath` | Add to project configuration                        |
| CSS not loading              | Wrong static file setup          | Use both `UseStaticFiles()` and `MapStaticAssets()` |
| Style conflicts              | Not using CSS isolation          | Create `.razor.css` files for components            |

## File Structure Example

```
Components/
├── Layout/
│   ├── NavMenu.razor
│   ├── NavMenu.razor.css     ← Component-scoped styles
│   ├── MainLayout.razor
│   └── MainLayout.razor.css  ← Component-scoped styles
└── Pages/
    ├── Home.razor
    └── Home.razor.css        ← Component-scoped styles
```

---
*This guide applies to .NET 9 Blazor projects. Earlier versions may have different requirements.*
