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
        throw
    }
}

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

$allCommands = (Get-Command Import-ADObjectEx).ScriptBlock.Ast.FindAll(
    {
        param (
            [System.Management.Automation.Language.Ast]$Ast
        )
        
        $Ast -is [System.Management.Automation.Language.CommandAst]
    },
    $true
)

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
    