$pattern = 'Apples: (?<AppleCount>\d+), Pears: (?<PearCount>\d+)'
Get-Content .\SampleFiles\sample_log.txt | ForEach-Object {
    $null = $_ -match $pattern
    if ($Matches) {
        [PSCustomObject]@{
            Apples = [int]$Matches.AppleCount
            Pears = [int]$Matches.PearCount
        }
    }
}

Select-String -Pattern $pattern -Path .\SampleFiles\sample_log.txt

$Matches

Get-Content .\SampleFiles\sample_log.txt | ForEach-Object {
    if ($_ -match $pattern) {
        [PSCustomObject]@{
            Apples = [int]$Matches.AppleCount
            Pears = [int]$Matches.PearCount
        }
    }
}
