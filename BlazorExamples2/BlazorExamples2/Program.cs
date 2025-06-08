using BlazorExamples2.Client.Pages;
using BlazorExamples2.Components;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents()
    .AddInteractiveWebAssemblyComponents();

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

app.UseStaticFiles(); // Use traditional static files for Azure compatibility

app.UseAntiforgery();

// Use MapStaticAssets for dev, traditional mapping for production
if (app.Environment.IsDevelopment())
{
    app.MapStaticAssets();
}
else
{
    app.UseStaticFiles();
}
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(BlazorExamples2.Client._Imports).Assembly);

app.Run();
