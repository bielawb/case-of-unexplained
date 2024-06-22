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

# Fix? We need to make sure we assing a value to the property...

Get-ADUser -Filter { Company -eq 'SouthPark' } -Properties * |
    Select-Object -Property GivenName, Surname, DisplayName, @{
        Name = 'CustomParameter'
        Expression = { $null }
    } |
    ConvertTo-Csv

Exit-PSSession
