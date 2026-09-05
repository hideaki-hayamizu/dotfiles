$projectRootDir = $PSScriptRoot

$isAlreadyInstalled = -1978335189

function IsAdmin
{
    [CmdletBinding(ConfirmImpact = "None")]
    [OutputType([bool])]
    param()

    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Launch elevated Windows PowerShell
if (($PSVersionTable.PSEdition -eq "Desktop") -and (-not (IsAdmin)))
{
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    exit
}

# Install PowerShell 7 MSIX and Launch
if (($PSVersionTable.PSEdition -eq "Desktop"))
{
    winget install --id Microsoft.PowerShell --source winget
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
    {
        Write-Error "Failed to install PowerShell 7."
        exit 1
    }

    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")

    Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    exit
}

# Install custom fonts
$fontFileExtsRegex = "\.(otf|ttf)$"

$windowsFontsDir = [Environment]::GetFolderPath("Fonts")
$windowsFontsRegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

$userFontsDir = Join-Path $projectRootDir "fonts"
if (-not (Test-Path -Path $userFontsDir)) {
    Write-Error "Cannot find dir: $userFontsDir"
    exit 1
}

$fontFiles = Get-ChildItem -Path $userFontsDir -File | Where-Object { $_.Name -match $fontFileExtsRegex }

foreach ($fontFile in $fontFiles) {
    try {
            $fontFileName = $fontFile.Name
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fontFileName)

            $familyName =  $baseName -replace "-", " "

            $fontRegName = ($familyName -creplace "(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])", " ") + " (TrueType)"

            $windowsFontFile = Join-Path $windowsFontsDir $fontFileName

            # copy the file
            if (-not (Test-Path -Path $windowsFontFile)) {
                Copy-Item -Path $fontFile.FullName -Destination $windowsFontFile -Force -ErrorAction Stop
            }

            # Add registry entry
            if (-not (Get-ItemProperty -Path $windowsFontsRegKey -Name $fontRegName -ErrorAction SilentlyContinue)) {
                New-ItemProperty -Path $windowsFontsRegKey -Name $fontRegName -PropertyType String -Value $fontFileName -Force -ErrorAction Stop | Out-Null
            }
        } catch {
            Write-Warning "Failed to install font: $($fontFile.Name)"
        }
}

# Create symlinks
$failedSymlinks = @()

$symlinkPaths = @(
    @{
        From = Join-Path $projectRootDir "gitui"
        To = Join-Path $env:APPDATA "gitui"
    }
    @{
        From = Join-Path $projectRootDir "mise"
        To = Join-Path $HOME ".config\mise"
    }
    @{
        From = Join-Path $projectRootDir "nvim"
        To = Join-Path $env:LOCALAPPDATA "nvim"
    }
    @{
        From = Join-Path $projectRootDir "wezterm"
        To = Join-Path $HOME ".config\wezterm"
    }
    @{
        From = Join-Path $projectRootDir "yazi\config"
        To = Join-Path $env:APPDATA "yazi\config"
    }
)

foreach ($link in $symlinkPaths) {
    $parentDir = Split-Path $link.To -Parent

    if (-not (Test-Path -Path $parentDir)) {
        try {
            New-Item -ItemType Directory -Path $parentDir -Force -ErrorAction Stop | Out-Null
        } catch {
            Write-Warning "Failed to create parent directory: $parentDir"
            $failedSymlinks += $link.To
            continue
        }
    }
    
    if (-not (Test-Path -Path $link.To)) {
        try {
            New-Item -ItemType SymbolicLink -Path $link.To -Target $link.From -Force -ErrorAction Stop | Out-Null
        } catch {
            Write-Warning "Failed to create symbolic link: $($link.To) -> $($link.From)"
            $failedSymlinks += $link.To
        }
    }
}

if ($failedSymlinks.Count -gt 0) {
    Write-Host "Failed to create symbolic links for the following paths:" -ForegroundColor Yellow
    $failedSymlinks | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}

# Create PowerShell profile
$profileLines = @(
    "(&mise activate pwsh --shims) | Out-String | Invoke-Expression"
)

try {
    if (-not (Test-Path $profile))
    {
        New-Item $profile -Force -ErrorAction Stop | Out-Null
        Set-Content -Path $profile -Value $profileLines
    }
    else
    {
        $profileContent = Get-Content -Path $profile -Raw -ErrorAction SilentlyContinue

        foreach ($line in $profileLines)
        {
            if ($profileContent -notmatch [regex]::Escape($line))
            {
                Add-Content -Path $profile -Value $line
            }
        }
    }
} catch {
    Write-Warning "Failed to create PowerShell profile: $profile"
}

# Install VisualStudio BuildTools 2022
winget install --scope machine --id Microsoft.VCRedist.2015+.x64 -e --silent --disable-interactivity --force --accept-source-agreements --accept-package-agreements --override "/quiet /norestart"
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
{
    Write-Error "Failed to install VC++ runtime."
    exit 1
}

$vsConfigPath = Join-Path $projectRootDir ".vsconfig"
$overrideArgs = "--passive --wait --norestart --config `"$vsConfigPath`""

winget install -e --id Microsoft.VisualStudio.2022.BuildTools --silent --disable-interactivity --accept-source-agreements --accept-package-agreements --override $overrideArgs
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
{
    Write-Error "Failed to install VisualStudio BuildTools."
    exit 1
}

$vcvarsPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
if (-not (Test-Path $vcvarsPath))
{
    Write-Error "Cannot find vcvars64: $vcvarsPath"
    exit 1
}
else
{
    $envOutput = cmd /c "`"$vcvarsPath`" && set"

    $include = ($envOutput | Select-String "^INCLUDE=").ToString().Substring(8)
    $lib     = ($envOutput | Select-String "^LIB=").ToString().Substring(4)
    $libpath = ($envOutput | Select-String "^LIBPATH=").ToString().Substring(8)

    [Environment]::SetEnvironmentVariable("INCLUDE",$include,"User")
    [Environment]::SetEnvironmentVariable("LIB",$lib,"User")
    [Environment]::SetEnvironmentVariable("LIBPATH",$libpath,"User")

    $msvcRoot = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC"
    $version = (Get-ChildItem $msvcRoot -Directory | Sort-Object Name -Descending | Select-Object -First 1).Name

    $msvcBinPath = Join-Path $msvcRoot "$version\bin\HostX64\x64"
    $roslynPath  = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\bin\Roslyn"
    $clangPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\bin"

    $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $pathsToAdd = @($msvcBinPath, $roslynPath, $clangPath) | Where-Object { $currentUserPath -notlike "*$_*" }

    if ($pathsToAdd.Count -gt 0)
    {
        $newUserPath = (@($currentUserPath.TrimEnd(";")) + $pathsToAdd) -join ";"
        [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
    }

    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
}

# Install mise-en-place & mise dev tools
winget install jdx.mise
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
{
    Write-Error "Failed to install mise-en-place."
    exit 1
}
else
{
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")

    try {
        mise install
    } catch {
        Write-Warning "Failed to install mise dev tools."
    }
}

# Install GNU tar
winget install -e --id GnuWin32.Tar
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
{
    Write-Error "Failed to install GNU tar."
    exit 1
}

# Install 7zip
winget install -e --id 7zip.7zip
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
{
    Write-Error "Failed to install 7zip."
    exit 1
}

# Install LuaJIT and LuaRocks
winget install --id DEVCOM.LuaJIT --silent --disable-interactivity --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
{
    Write-Error "Failed to install LuaJIT and LuaRocks."
    exit 1
}

# Install ImageMagick
winget install -e --id ImageMagick.ImageMagick --silent --disable-interactivity --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $isAlreadyInstalled)
{
    Write-Error "Failed to install ImageMagick."
    exit 1
}

# Install WezTerm nightly
$weztermNightlyUrl = "https://github.com/wezterm/wezterm/releases/download/nightly/WezTerm-nightly-setup.exe"

$tempDir = Join-Path $env:TEMP "wezterm-nightly"
if (-not (Test-Path -Path $tempDir))
{
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

$weztermInstallerPath = Join-Path $tempDir "WezTerm-nightly-setup.exe"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    Invoke-WebRequest -Uri $weztermNightlyUrl -OutFile $weztermInstallerPath -UseBasicParsing
} catch {
    Write-Error "Failed to download WezTerm nightly."
    exit 1
}

try {
    Start-Process -FilePath $weztermInstallerPath -ArgumentList "/verysilent /norestart /suppressmsgboxes" -Wait
} catch {
    Write-Error "Failed to install WezTerm nightly."
    exit 1
}

Remove-Item -Path $weztermInstallerPath -Force -ErrorAction SilentlyContinue

# Get providers for Neovim
$venvPath = Join-Path $HOME ".venvs\nvim"

if (-not (Test-Path $venvPath)) {
    $venvDir = Split-Path $venvPath -Parent

    if (-not (Test-Path $venvDir)) {
        try {
            New-Item -ItemType Directory -Path $venvDir -Force -ErrorAction Stop | Out-Null
        } catch {
            Write-Warning "Failed to create parent directory: $venvDir"
            return
        }
    }

    mise exec -- uv venv $venvPath
    mise exec -- uv pip install --python "$venvPath\Scripts\python.exe" pynvim
}

mise exec -- npm install -g neovim

# Succeeded to install
Write-Host "Setup script finished." -ForegroundColor Green -NoNewLine
[Console]::ReadKey($true) > $null