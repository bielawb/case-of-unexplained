Import-Module -Name .\SampleFiles\MyModule.psm1
$ast = [System.Management.Automation.Language.Parser]::ParseFile(
    (Convert-Path -Path SampleFiles\MyModule.psm1),
    [ref]$null,[ref]$null
)

$search = $ast.FindAll(
    {
        $args[0] -is [System.Management.Automation.Language.SubExpressionAst]
    },
    $true
)

$search | ForEach-Object -Process { $_.SubExpression.Extent.Text.Length }
$ast.Extent.Text.Length

@(Get-Content -Path .\SampleFiles\MyModule.psm1)[$search[0].Extent.StartLineNumber - 1]