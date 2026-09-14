# pwsh
Set-PSReadLineOption -HistorySaveStyle SaveNothing

# mise-en-place
(&mise activate pwsh --shims) | Out-String | Invoke-Expression

# GitUI
function GetWindowsTheme {
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $value = (Get-ItemProperty -Path $key -Name AppsUseLightTheme -ErrorAction SilentlyContinue).AppsUseLightTheme
    if ($value -eq 0) {
        return "Dark"
    } else {
        return "Light"
    }
}

function gitui {
    $theme = GetWindowsTheme
    $themeFile = if ($theme -eq "Dark") { "dark.ron" } else { "light.ron" }
    & (Get-Command gitui -CommandType Application).Source -t $themeFile
}
