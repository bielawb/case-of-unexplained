$value = Get-Content -Path C:\PowerShell\PSConfEU\case-of-unexplained\Demos\SampleFiles\my_var_value.txt
@{
    value = $value
} | ConvertTo-Json