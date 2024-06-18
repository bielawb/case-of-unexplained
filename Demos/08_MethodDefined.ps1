class Employee {
    [string]$Login
    [bool]$Mailbox
    [bool]$HomeFolder
    [bool]$VDI
    
    [bool] LeaverProcessComplete () {
        return -not (
            $this.Mailbox -or
            $this.HomeFolder -or
            $this.VDI
        )
    }
}

$me = [Employee]@{
    Login = 'bielawb'
    Mailbox = $true
    HomeFolder = $false
    VDI = $false
}

if ($me.LeaverProcessComplete) {
    '{0} is complete! Despite {1} being true...' -f @(
        $me.Login,
        ($me.PSObject.Properties.Where{ $_.TypeNameOfValue -eq 'System.Boolean' -and $_.Value }.Name)
    )
}

$me.LeaverProcessComplete
[bool]$me.LeaverProcessComplete
[bool]$me.LeaverProcessComplete()
[Employee]@{
    VDI = $false
    Mailbox = $false
    HomeFolder = $false
} | ForEach-Object -MemberName LeaverProcessComplete
