# Problem: re-factoring breaks the code with weird error message...
function Import-ADObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Path
    )

    try {
        Import-Clixml -Path $Path -ErrorAction Stop
    } catch {
        Write-Log -ErrorRecord $_ -Message "Failed to import file: $Path"
    }
}

# Splatting FTW!
function Import-ADObjectEx {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Path
    )

    try {
        $splat = @{
            Path = $Path
            ErrorAction = Stop
        }
        Import-Clixml @splat
    } catch {
        Write-Log -ErrorRecord $_ -Message "Failed to import file: $Path"
        throw
    }
}

# Running function results in an error
Import-ADObjectEx -Path .\SampleFiles\ADResult.clixml

# Where is the stop located...?

# Solution - AST to the rescue! Lets find ALL commands first...
$allCommands = (Get-Command Import-ADObjectEx).ScriptBlock.Ast.FindAll(
    {
        param (
            [System.Management.Automation.Language.Ast]$Ast
        )
        
        $Ast -is [System.Management.Automation.Language.CommandAst]
    },
    $true
)

$allCommands | Format-Table

# Easy to find here, but if we have way more commands...? We can filter even more!
$stopCommand = (Get-Command Import-ADObjectEx).ScriptBlock.Ast.FindAll(
    {
        param (
            [System.Management.Automation.Language.Ast]$Ast
        )
        
        $Ast -is [System.Management.Automation.Language.CommandAst] -and
        $Ast.GetCommandName() -eq 'Stop'
    },
    $true
)

$stopCommand
$stopCommand[0].Extent.StartLineNumber

# A trick to get LineNumbers for a function in the memory...
Get-Command -Name Import-ADObjectEx |
    ForEach-Object -Process { $_.ScriptBlock.ToString() -split '\n' } |
    Select-String -Pattern .* |
    Select-Object -Property LineNumber, Line

# Solution - make sure to use quotes where needed whenever converting to splatting