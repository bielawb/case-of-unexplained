# Problem: using methods in the if statement can produce unexpected results
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

# Lets create instance of object that should *not* be Leaver Process Complete
$me = [Employee]@{
    Login = 'bielawb'
    Mailbox = $true
    HomeFolder = $false
    VDI = $false
}

# Using if, accessing method, wrong result...
if ($me.LeaverProcessComplete) {
    '{0} is complete! Despite {1} being true...' -f @(
        $me.Login,
        ($me.PSObject.Properties.Where{ $_.TypeNameOfValue -eq 'System.Boolean' -and $_.Value }.Name)
    )
}

# Displaying method definition vs. calling that method
$me.LeaverProcessComplete
[bool]$me.LeaverProcessComplete
[bool]$me.LeaverProcessComplete()
[Employee]@{
    VDI = $false
    Mailbox = $false
    HomeFolder = $false
} | ForEach-Object -MemberName LeaverProcessComplete

# Solution: make sure you call a method to get a proper result!