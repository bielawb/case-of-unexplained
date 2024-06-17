# Expected - adding empty property using Select-Object
Get-Process | Select-Object -Property Name, Id, FooBar -First 3 | Tee-Object -Variable proc | ConvertTo-Csv
$proc | ConvertTo-Json

# Not expected - AD makes up properties
Enter-PSSession -ComputerName 192.168.56.10 -Credential igo\admin

Get-ADUser -Filter { Company -eq 'SouthPark' } -Properties * |
    Select-Object -Property GivenName, Surname, DisplayName, CustomParameter |
    Tee-Object -Variable ad |
    ConvertTo-Csv

$ad | ConvertTo-Json

Exit-PSSession

#region Demo in the VM... Exported results:

$objects = Import-Clixml -Path .\SampleFiles\ADResult.clixml

$objects | ConvertTo-Json
$objects | ConvertTo-Csv
Get-Content -Path .\SampleFiles\result.csv
#endregion