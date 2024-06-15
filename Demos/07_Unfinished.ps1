Import-Module -Name "$PSScriptRoot\SampleFiles\MyModule.psm1"
$ast = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\SampleFiles\MyModule.psm1", [ref]$null, [ref]$null)
$search = $ast.FindAll(
    {
        $args[0] -is [System.Management.Automation.Language.SubExpressionAst]
    },
    $true
)
