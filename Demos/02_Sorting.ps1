git status
Import-Module .\SampleFiles\SampleFiles.psm1
Export-PowerShellDataFile -Data (
        Import-PowerShellDataFile -Path SampleFiles\02_sort_test.psd1
    ) -Path SampleFiles\02_sort_test.psd1
git status

'aa', 'a-' | Sort-Object
'a-b', 'aa' | Sort-Object

Start-Process -FilePath https://github.com/PowerShell/PowerShell/issues/3425