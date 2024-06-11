function Get-Foo {
    param (
        [String]$Name
    )
    
    "Foo is $Name at $(Get-Date -Date (Get-Date).AddDays(5) -Format 'yyyy-MM-dd'"

}

