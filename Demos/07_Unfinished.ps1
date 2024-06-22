# Problem: importing module fails with last line of specific function listed as broken
Import-Module -Name .\SampleFiles\MyModule.psm1

# Same story - we can't debug, but we can use AST!
$ast = [System.Management.Automation.Language.Parser]::ParseFile(
    (Convert-Path -Path SampleFiles\MyModule.psm1),
    [ref]$null,[ref]$null
)

# Problem with subexpression? Lets find all of them!
$search = $ast.FindAll(
    {
        $args[0] -is [System.Management.Automation.Language.SubExpressionAst]
    },
    $true
)

$search | Format-Table
$search | ForEach-Object -Process { $_.SubExpression.Extent.Text.Length }
$ast.Extent.Text.Length

@(Get-Content -Path .\SampleFiles\MyModule.psm1)[$search[0].Extent.StartLineNumber - 1]

# Solution: add missing bracket to make subexpression complete