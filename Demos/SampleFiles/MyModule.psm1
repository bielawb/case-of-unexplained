function Get-LogPath {
    param (
        [String]$Path,
        [String]$Name
    )
    
    $logFile = Join-Path -Path $Path -ChildPath $("Foo_Bar_{0}.log" -f (Get-Date -Format 'yyyyMMddHHmmss')
    
    <#

        There is a lot of code here...
        Imagine pages, and pages of code...



    #>

    foreach ($item in 1..20) {
        "This is $($item)"
    }

    if ($item -gt 20) {
        "Item is above $($item)"
    }
}
