Import-Module -Name C:\PowerShell\PSConfEU\case-of-unexplained\Demos\SampleFiles\SampleFiles.psm1

# Function that generates data files with nice sorting...
Export-PowerShellDataFile -Data (
        Import-PowerShellDataFile -Path C:\PowerShell\PSConfEU\case-of-unexplained\Demos\SampleFiles\02_sort_test.psd1
    ) -Path C:\PowerShell\PSConfEU\case-of-unexplained\Demos\SampleFiles\02_sort_test.psd1
