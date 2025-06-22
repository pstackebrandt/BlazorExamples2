# Versioning Strategy

## Current Version

**Version**: 1.1.0  
**AssemblyVersion**: 1.1.0.0  
**FileVersion**: 1.1.0.0  
**PackageVersion**: 1.1.0

## Version Number Format

We follow **Semantic Versioning (SemVer)** with the format: `MAJOR.MINOR.PATCH`

- **MAJOR** (1): Breaking changes, major feature releases
- **MINOR** (1): New features, backward-compatible additions
- **PATCH** (0): Bug fixes, minor improvements

## Version Types Explained

### Version

- Used for NuGet packages and general version identification
- Format: `MAJOR.MINOR.PATCH` (e.g., 1.1.0)

### AssemblyVersion

- .NET assembly version used for binding and compatibility
- Format: `MAJOR.MINOR.PATCH.BUILD` (e.g., 1.1.0.0)
- Used by the .NET runtime for assembly loading

### FileVersion

- Windows file version shown in file properties
- Format: `MAJOR.MINOR.PATCH.BUILD` (e.g., 1.1.0.0)
- Displayed in Windows Explorer and system dialogs

### PackageVersion

- Specific version for NuGet package publishing
- Format: `MAJOR.MINOR.PATCH` (e.g., 1.1.0)

## When to Increase Version Numbers

### MAJOR Version (1.x.x → 2.0.0)

Increase when:

- Breaking changes to public APIs
- Major architectural changes
- Incompatible changes to existing functionality
- Complete rewrite of major components
- Changes that require users to modify their code

**Examples:**

- Removing public methods or properties
- Changing method signatures
- Breaking changes in configuration
- Major UI/UX redesigns

### MINOR Version (1.1.x → 1.2.0)

Increase when:

- New features added (backward-compatible)
- New components or pages added
- Enhanced existing functionality
- New configuration options
- Performance improvements

**Examples:**

- Adding new Blazor components
- New API endpoints
- Additional styling options
- New utility functions
- Enhanced error handling

### PATCH Version (1.1.0 → 1.1.1)

Increase when:

- Bug fixes
- Security patches
- Minor improvements
- Documentation updates
- Code cleanup

**Examples:**

- Fixing UI rendering issues
- Correcting validation logic
- Updating dependencies
- Fixing typos in documentation
- Performance optimizations

## Central Version Management

### Directory.Build.props

Contains central version definitions for all projects in the solution:

```xml
<PropertyGroup>
    <Version>1.1.0</Version>
    <AssemblyVersion>1.1.0.0</AssemblyVersion>
    <FileVersion>1.1.0.0</FileVersion>
    <PackageVersion>1.1.0</PackageVersion>
</PropertyGroup>
```

### Directory.Packages.props

Manages central package versioning for NuGet dependencies:

```xml
<PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
</PropertyGroup>
```

## How to Update Versions

### Step 1: Update Directory.Build.props

Edit the version numbers in `Directory.Build.props`:

```xml
<Version>1.2.0</Version>           <!-- For new features -->
<AssemblyVersion>1.2.0.0</AssemblyVersion>
<FileVersion>1.2.0.0</FileVersion>
<PackageVersion>1.2.0</PackageVersion>
```

### Step 2: Update This Documentation

- Update the "Current Version" section
- Add entry to version history if needed

### Step 3: Update Package Versions (if needed)

Edit `Directory.Packages.props` to update NuGet package versions:

```xml
<PackageVersion Include="PackageName" Version="NewVersion" />
```

### Step 4: Commit Changes

- Use conventional commit format: `feat: bump version to 1.2.0`
- Include version update in commit message

## Version History

| Version | Date    | Changes                                       |
| ------- | ------- | --------------------------------------------- |
| 1.1.0   | Initial | Initial version with central versioning setup |

## Best Practices

1. **Always update this file** when changing versions
2. **Use conventional commits** for version-related changes
3. **Test thoroughly** after version updates
4. **Document breaking changes** clearly
5. **Consider release notes** for major/minor versions
6. **Tag releases** in Git for important versions

## Tools and Commands

### Check Current Version

```powershell
# Build the project to see version information
dotnet build
```

### Update Package Versions

```powershell
# Update all packages to latest versions
dotnet list package --outdated
dotnet add package PackageName --version NewVersion
```

### Create Release Tag

```powershell
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0
```

## Notes

- Assembly and File versions use 4-part format for Windows compatibility
- Package versions use 3-part format for NuGet compatibility
- All version numbers are managed centrally in `Directory.Build.props`
- Package dependencies are managed in `Directory.Packages.props`
