<#
TODO:
    - get xml from a VM
    - finish samples
#>
# Demo in the VM... Exported results:
$objects = Import-Clixml -Path .\SampleFiles\ADResult.clixml

$objects | ConvertTo-Json
$objects | ConvertTo-Csv
Get-Content -Path .\SampleFiles\result.csv