using BlazorExamples2.Client.Pages;
using BlazorExamples2.Components;
using BlazorExamples2.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents()
    .AddInteractiveWebAssemblyComponents();

// Register version service
builder.Services.AddScoped<IVersionService, VersionService>();

// Add health checks
builder.Services.AddHealthChecks();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
}
else
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

// Azure handles HTTPS termination, so only redirect in development
if (app.Environment.IsDevelopment())
{
    app.UseHttpsRedirection();
}

app.UseAntiforgery();

// Static files handling - Modern .NET 9 approach
// UPDATED: Azure App Service now fully supports MapStaticAssets() as of .NET 9 GA (Nov 2024)
// See: AZURE-MAPSTATIC-ASSETS-COMPATIBILITY.md for details
// FALLBACK: If deployment fails, replace with: app.UseStaticFiles();
app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(BlazorExamples2.Client._Imports).Assembly);

// Map health check endpoint
app.MapHealthChecks("/health");

app.Run();
