# mise
# yes: Microsoft.PowerShell (pwsh) (version 7), no: Windows PowerShell(version 5)

# winget install jdx.mise
# mise activate pwsh -> When you run it, the content to be added to the profile will be output, so add it to the profile file.
# Add this directory to PATH: C:\Users\UserName\AppData\Local\mise\shims
# Run mise doctor -> shims_on_path: yes

mise activate pwsh | Out-String | Invoke-Expression

# do not show predictive text
Set-PSReadlineOption -HistorySaveStyle SaveNothing