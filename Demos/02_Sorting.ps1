<# 
TODO:
    - get function Export-PowerShellDataFile
    - generate sample psd1
    - find a link to GitHub issue 
#>

git status
Import-Module .\SampleFiles\SampleFiles.psm1
Export-PowerShellDataFile -Data (Import-PowerShellDataFile -Path SampleFiles\02_sort_test.psd1) -Path SampleFiles\02_sort_test.psd1
git status

'aa', 'a-' | Sort-Object
'a-b', 'aa' | Sort-Object