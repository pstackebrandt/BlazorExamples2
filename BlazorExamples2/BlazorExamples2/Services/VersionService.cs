using System.Reflection;

namespace BlazorExamples2.Services;

public interface IVersionService
{
    string GetVersion();
}

public class VersionService : IVersionService
{
    public string GetVersion()
    {
        var version = Assembly.GetExecutingAssembly().GetName().Version;
        if (version != null)
        {
            return $"Version {version.Major}.{version.Minor}.{version.Build}";
        }
        return "Version unknown";
    }
} 