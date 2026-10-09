$projectRootDir = $PSScriptRoot

# winget exit codes treated as success: OK / no applicable update / already installed
$wingetOkCodes = @(0, -1978335189, -1978335135)

#region Helpers
function Fail
{
    param([string]$Message)

    Write-Error $Message
    [Console]::ReadKey($true) > $null
    exit 1
}

function IsAdmin
{
    [CmdletBinding(ConfirmImpact = "None")]
    [OutputType([bool])]
    param()

    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-WingetPackage
{
    param(
        [Parameter(Mandatory)][string]$Id,
        [string[]]$ExtraArgs = @()
    )

    winget install -e --id $Id --silent --disable-interactivity --accept-source-agreements --accept-package-agreements @ExtraArgs
    if ($LASTEXITCODE -notin $wingetOkCodes)
    {
        Fail "Failed to install $Id. (ExitCode: $LASTEXITCODE)"
    }
}

function Update-SessionPath
{
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
}

function Add-UserPath
{
    param([Parameter(Mandatory)][string]$Dir)

    # @() keeps $entries an array even when there is only one entry
    $entries = @([Environment]::GetEnvironmentVariable("Path", "User") -split ";" | Where-Object { $_ })

    if ($entries -notcontains $Dir)
    {
        [Environment]::SetEnvironmentVariable("Path", (($entries + $Dir) -join ";"), "User")
    }
}

function Get-VcVar
{
    param([string[]]$Lines, [string]$Name)

    $line = $Lines | Where-Object { $_ -like "$Name=*" } | Select-Object -First 1
    if (-not $line)
    {
        Fail "Cannot find $Name in vcvars64 output."
    }

    return $line.Substring($Name.Length + 1)
}

#endregion

# Relaunch as administrator
if (-not (IsAdmin))
{
    $shell = if ($PSVersionTable.PSEdition -eq "Desktop") { "powershell" } else { "pwsh" }
    Start-Process $shell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Install PowerShell 7 and relaunch with it
if ($PSVersionTable.PSEdition -eq "Desktop")
{
    Install-WingetPackage "Microsoft.PowerShell" @("--source", "winget")
    Update-SessionPath

    Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Install custom fonts
$fontFileExtsRegex = "\.(otf|ttf)$"

$windowsFontsDir = [Environment]::GetFolderPath("Fonts")
$windowsFontsRegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

$userFontsDir = Join-Path $projectRootDir "fonts"
if (-not (Test-Path -Path $userFontsDir))
{
    Fail "Cannot find dir: $userFontsDir"
}

$fontFiles = Get-ChildItem -Path $userFontsDir -File | Where-Object { $_.Name -match $fontFileExtsRegex }

foreach ($fontFile in $fontFiles)
{
    try
    {
        $fontFileName = $fontFile.Name
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fontFileName)
        $familyName = $baseName -replace "-", " "
        $fontRegName = ($familyName -creplace "(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])", " ") + " (TrueType)"
        $windowsFontFile = Join-Path $windowsFontsDir $fontFileName

        # Copy the file
        if (-not (Test-Path -Path $windowsFontFile))
        {
            Copy-Item -Path $fontFile.FullName -Destination $windowsFontFile -Force -ErrorAction Stop
        }

        # Add registry entry
        if (-not (Get-ItemProperty -Path $windowsFontsRegKey -Name $fontRegName -ErrorAction SilentlyContinue))
        {
            New-ItemProperty -Path $windowsFontsRegKey -Name $fontRegName -PropertyType String -Value $fontFileName -Force -ErrorAction Stop | Out-Null
        }
    }
    catch
    {
        Write-Warning "Failed to install font: $($fontFile.Name)"
    }
}

# Create symlinks
$failedSymlinks = @()

$symlinkPaths = @(
    @{
        From = Join-Path $projectRootDir "gitui"
        To   = Join-Path $env:APPDATA "gitui"
    }
    @{
        From = Join-Path $projectRootDir "mise"
        To   = Join-Path $HOME ".config\mise"
    }
    @{
        From = Join-Path $projectRootDir "nvim"
        To   = Join-Path $env:LOCALAPPDATA "nvim"
    }
    @{
        From = Join-Path $projectRootDir "wezterm"
        To   = Join-Path $HOME ".config\wezterm"
    }
    @{
        From = Join-Path $projectRootDir "yazi\config"
        To   = Join-Path $env:APPDATA "yazi\config"
    }
)

foreach ($link in $symlinkPaths)
{
    $parentDir = Split-Path $link.To -Parent

    if (-not (Test-Path -Path $parentDir))
    {
        try
        {
            New-Item -ItemType Directory -Path $parentDir -Force -ErrorAction Stop | Out-Null
        }
        catch
        {
            Write-Warning "Failed to create parent directory: $parentDir"
            $failedSymlinks += $link.To
            continue
        }
    }

    # Get-Item -Force also finds broken symlinks, which Test-Path does not
    $existing = Get-Item -Path $link.To -Force -ErrorAction SilentlyContinue

    if ($existing)
    {
        if ($existing.LinkType -eq "SymbolicLink" -and (@($existing.Target) -contains $link.From))
        {
            continue
        }

        if ($existing.LinkType -eq "SymbolicLink")
        {
            # Points somewhere else: replace the link (only the link is removed, not its target)
            try
            {
                Remove-Item -Path $link.To -Force -ErrorAction Stop
            }
            catch
            {
                Write-Warning "Failed to replace existing symbolic link: $($link.To)"
                $failedSymlinks += $link.To
                continue
            }
        }
        else
        {
            Write-Warning "Already exists and is not a symbolic link, skipped: $($link.To)"
            $failedSymlinks += $link.To
            continue
        }
    }

    try
    {
        New-Item -ItemType SymbolicLink -Path $link.To -Target $link.From -ErrorAction Stop | Out-Null
    }
    catch
    {
        Write-Warning "Failed to create symbolic link: $($link.To) -> $($link.From)"
        $failedSymlinks += $link.To
    }
}

if ($failedSymlinks.Count -gt 0)
{
    Write-Host "Symbolic links were not created for the following paths:" -ForegroundColor Yellow
    $failedSymlinks | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}

# Create PowerShell profile
$pwshProfileDataPath = Join-Path $projectRootDir "profile\pwsh.ps1"
# MyDocuments follows OneDrive folder redirection, $HOME\Documents does not
$pwshProfilePath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell\Microsoft.PowerShell_profile.ps1"

try
{
    if (-not (Test-Path $pwshProfileDataPath))
    {
        throw "Profile template not found: $pwshProfileDataPath"
    }

    $needCreate = $true
    $existingItem = Get-Item -Path $pwshProfilePath -Force -ErrorAction SilentlyContinue

    if ($existingItem)
    {
        if ($existingItem.LinkType -eq "SymbolicLink")
        {
            if (@($existingItem.Target) -contains $pwshProfileDataPath)
            {
                Write-Host "Symlink already up to date: $pwshProfilePath"
                $needCreate = $false
            }
            else
            {
                Remove-Item -Path $pwshProfilePath -Force -ErrorAction Stop
            }
        }
        else
        {
            $backupPath = "$pwshProfilePath.bak"
            Write-Warning "Existing profile is a regular file. Backing up to: $backupPath"
            Move-Item -Path $pwshProfilePath -Destination $backupPath -Force -ErrorAction Stop
        }
    }
    else
    {
        $parentDir = Split-Path -Path $pwshProfilePath -Parent
        if (-not (Test-Path $parentDir))
        {
            New-Item -Path $parentDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
        }
    }

    if ($needCreate)
    {
        New-Item -Path $pwshProfilePath -ItemType SymbolicLink -Target $pwshProfileDataPath -ErrorAction Stop | Out-Null
        Write-Host "Symlink created: $pwshProfilePath -> $pwshProfileDataPath"
    }
}
catch
{
    Write-Warning "Failed to create PowerShell profile symlink: $pwshProfilePath ($_)"
}

# Install VisualStudio BuildTools 2022
$vsConfigPath = Join-Path $projectRootDir ".vsconfig"
$overrideArgs = "--passive --wait --norestart --config `"$vsConfigPath`""

Install-WingetPackage "Microsoft.VisualStudio.2022.BuildTools" @("--override", $overrideArgs)

$vcvarsPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
if (-not (Test-Path $vcvarsPath))
{
    Fail "Cannot find vcvars64: $vcvarsPath"
}

$envOutput = cmd /c "`"$vcvarsPath`" && set"

foreach ($name in "INCLUDE", "LIB", "LIBPATH")
{
    [Environment]::SetEnvironmentVariable($name, (Get-VcVar $envOutput $name), "User")
}

$msvcRoot = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC"
$version = (Get-ChildItem $msvcRoot -Directory | Sort-Object { [version]$_.Name } -Descending | Select-Object -First 1).Name

if (-not $version)
{
    Fail "MSVC tools not found under: $msvcRoot"
}

Add-UserPath (Join-Path $msvcRoot "$version\bin\HostX64\x64")
Add-UserPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\bin\Roslyn"
Add-UserPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\x64\bin"
Update-SessionPath

# Install mise-en-place & mise dev tools
Install-WingetPackage "jdx.mise"
Update-SessionPath

$miseAvailable = [bool](Get-Command mise -ErrorAction SilentlyContinue)
if ($miseAvailable)
{
    mise install
    if ($LASTEXITCODE -ne 0)
    {
        Write-Warning "Failed to install mise dev tools."
    }
}
else
{
    Write-Warning "mise was not found on PATH. Skipping mise dev tools and Neovim providers."
}

# Install GNU tar
Install-WingetPackage "GnuWin32.Tar"

# Install 7zip
Install-WingetPackage "7zip.7zip"
Add-UserPath "C:\Program Files\7-Zip"

# Install LuaJIT (check that `luarocks --version` works afterwards)
Install-WingetPackage "DEVCOM.LuaJIT"

# Install ImageMagick
Install-WingetPackage "ImageMagick.ImageMagick"

Update-SessionPath

# Install WezTerm nightly
$weztermNightlyUrl = "https://github.com/wezterm/wezterm/releases/download/nightly/WezTerm-nightly-setup.exe"

if (Get-Process -Name "wezterm-gui" -ErrorAction SilentlyContinue)
{
    Write-Warning "WezTerm is running. The installer may fail to replace its files; close WezTerm and re-run if it does."
}

$tempDir = Join-Path $env:TEMP "wezterm-nightly"
if (-not (Test-Path -Path $tempDir))
{
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

$weztermInstallerPath = Join-Path $tempDir "WezTerm-nightly-setup.exe"

try
{
    # The progress bar makes Invoke-WebRequest much slower
    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri $weztermNightlyUrl -OutFile $weztermInstallerPath -ErrorAction Stop
}
catch
{
    Fail "Failed to download WezTerm nightly. ($_)"
}

$installer = Start-Process -FilePath $weztermInstallerPath -ArgumentList "/verysilent /norestart /suppressmsgboxes" -Wait -PassThru
if ($installer.ExitCode -ne 0)
{
    Fail "Failed to install WezTerm nightly. (ExitCode: $($installer.ExitCode))"
}

Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# Get providers for Neovim
if ($miseAvailable)
{
    $venvPath = Join-Path $HOME ".venvs\nvim"
    $venvPython = Join-Path $venvPath "Scripts\python.exe"

    if (-not (Test-Path $venvPython))
    {
        $venvDir = Split-Path $venvPath -Parent

        if (-not (Test-Path $venvDir))
        {
            try
            {
                New-Item -ItemType Directory -Path $venvDir -Force -ErrorAction Stop | Out-Null
            }
            catch
            {
                Write-Warning "Failed to create parent directory: $venvDir"
            }
        }

        mise exec -- uv venv $venvPath
        if ($LASTEXITCODE -ne 0)
        {
            Write-Warning "Failed to create venv: $venvPath"
        }
    }

    # uv pip install is idempotent, so run it every time
    if (Test-Path $venvPython)
    {
        mise exec -- uv pip install --python $venvPython pynvim
        if ($LASTEXITCODE -ne 0)
        {
            Write-Warning "Failed to install pynvim."
        }
    }

    mise exec -- npm install -g neovim
    if ($LASTEXITCODE -ne 0)
    {
        Write-Warning "Failed to install neovim npm package."
    }
}

# Succeeded to install
Write-Host "Setup script finished." -ForegroundColor Green -NoNewline
[Console]::ReadKey($true) > $null