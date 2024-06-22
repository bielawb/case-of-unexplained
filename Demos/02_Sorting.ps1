# Problem...
git status
Import-Module -Name .\SampleFiles\SampleFiles.psm1
Export-PowerShellDataFile -Data (
        Import-PowerShellDataFile -Path SampleFiles\02_sort_test.psd1
    ) -Path SampleFiles\02_sort_test.psd1
git status
git diff
git checkout -- SampleFiles\02_sort_test.psd1

# why? imaging script that does simple sorting in 2 similar scenarios...
Get-Content -Path .\SampleFiles\SortScript.ps1

# Running this script in PS5
.\SampleFiles\SortScript.ps1

# Running the same script in PS7
pwsh.exe -noprofile -file .\SampleFiles\SortScript.ps1

# Solution - use either - not both!

# Issue on GitHub
Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/issues/3425 |
    Format-List -Property state, title, body
