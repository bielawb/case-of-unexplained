git status
Import-Module -Name .\SampleFiles\SampleFiles.psm1
Export-PowerShellDataFile -Data (
        Import-PowerShellDataFile -Path SampleFiles\02_sort_test.psd1
    ) -Path SampleFiles\02_sort_test.psd1
git status
git diff
git checkout -- SampleFiles\02_sort_test.psd1

Get-Content -Path .\SampleFiles\SortScript.ps1

.\SampleFiles\SortScript.ps1

pwsh.exe -noprofile -file .\SampleFiles\SortScript.ps1

Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/issues/3425 |
    Format-List -Property state, title, body