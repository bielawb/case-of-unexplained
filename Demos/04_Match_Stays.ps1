# Problem: $Matches is not cleaned when patter matching fails!
$pattern = 'Apples: (?<AppleCount>\d+), Pears: (?<PearCount>\d+)'
Get-Content .\SampleFiles\sample_log.txt
Get-Content .\SampleFiles\sample_log.txt | ForEach-Object {
    $null = $_ -match $pattern
    if ($Matches) {
        [PSCustomObject]@{
            Apples = [int]$Matches.AppleCount
            Pears = [int]$Matches.PearCount
        }
    }
}

# Lets see how $Matches ignores everything except successful -match and won't change even when it fails
Select-String -Pattern $pattern -Path .\SampleFiles\sample_log.txt
'this' -match 'that'
$Matches
'foo' -match 'o'
$Matches

# Solution: verify that we got a match before doing anything else!
Get-Content .\SampleFiles\sample_log.txt | ForEach-Object {
    if ($_ -match $pattern) {
        [PSCustomObject]@{
            Apples = [int]$Matches.AppleCount
            Pears = [int]$Matches.PearCount
        }
    }
}
