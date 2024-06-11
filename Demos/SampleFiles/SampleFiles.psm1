Function Export-PowerShellDataFile {
    Param (
        # Path to the new datafile
        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [ValidateScript({Test-Path -LiteralPath (Split-Path -Path $_)})]
        [String]$Path,

        # Export to String instead of to file
        [Parameter(Mandatory, ParameterSetName = 'ToString')]
        [switch]$ToString,

        # Data that will be written inside the powershelldatafile
        [Parameter(Mandatory)]
        [hashtable]$Data,

        # Also sort Arrays, cannot be done on certain files when the order of the array matters (ie. @('0x01', '0x33', '0x12'))
        [string[]]$SortArrayNotforKeys = @('Day', 'DnsNameList', 'MonthsOfYear', 'Value')
    )

    Function Format-Value {
        [CmdletBinding()]
        [OutputType([string])]
        Param(
            # Value to be formatted
            [Object]$Value
        )

        $valueTemplate = switch ($Value) {
            {$null -eq $_} { '$null' }
            {$_ -is [int] -or $_ -is [int64]} { "{0}"  }
            {$_ -is [boolean]} { "`${0}"  }
            {$_ -is [datetime]} { "'{0:s}'" }
            # scriptblock from a psd file has additional set of curlies - INC-22137
            {$_ -is [scriptblock] -and $_ -like '{*}'} { "{0}" } 
            {$_ -is [scriptblock] -and $_ -notlike '{*}'} { "{{{0}}}" } 
            {$_ -is [String] -and $_.contains("`n")} { "@'`r`n{0}`r`n'@" }
            default { "'{0}'" }
        }
        if ($Value -is [string] -and -not $Value.contains("`n")) {
            #Escape single quotes in the string with a double quote to prevent running into issues, if it is multiline, this should not be done.
            $Value = $Value | ForEach-Object {$_ -replace '''', ''''''}
        }

        return $valueTemplate -f $Value
    }

    Function Add-PowerShellDataObject {
        [CmdletBinding(
            DefaultParameterSetName = 'Line'
        )]
        Param (
            # StringBuilder Reference where the line will be added to.
            [Parameter(Mandatory)]
            [System.Text.StringBuilder]$StringBuilder,

            # Key of a key value pair that is added to the stringbuilder
            [string]$Key,

            # Value of the key value pair that is added to the stringbuilder
            [Parameter(Mandatory)]
            [AllowNull()]
            [Object]$Value,

            # Indentation that will be in front of the string added, 4 spaces per Indentlevel
            [int]$Indentlevel = 0,

            # Also sort Arrays, cannot be done on certain files when the order of the array matters (ie. @('0x01', '0x33', '0x12'))
            [string[]]$SortArrayNotforKeys
        )

        # Put the key in single quotes when there is a dot (.), space ( ) or dash (-) in the key, or it starts with a numerical character
        if ($Key -match '[. -]|^[0-9]') {
            $Key = "'$Key'"
        }

        $indentation = "$('    ' * $Indentlevel)"
        if ($Value -is [hashtable]) {
            if ($Key) {
                $null = $StringBuilder.AppendLine($indentation + $Key + " = @{")
            } else {
                $null = $StringBuilder.AppendLine("$indentation@{")
            }

            # Sorting Keys, placing AllNodes first, then Name, than alphabetic order
            $Value.Keys | Sort-Object -Property {if ($_ -eq 'AllNodes') { 1 } elseif ($_ -eq 'Name') { 2 } else { 3 }}, { $_ } | ForEach-Object {
                Add-PowerShellDataObject $StringBuilder -Indentlevel ($Indentlevel + 1) -Value $Value[$_] -Key $_ -SortArrayNotforKeys $SortArrayNotforKeys
            }
            $null = $StringBuilder.AppendLine("$indentation}")
        } elseif ($Value -is [System.Array]) {
            if ($Value.Count -eq 0) {
                $null = $StringBuilder.AppendLine($indentation + "$Key = @()")
            } else {
                $null = $StringBuilder.AppendLine($indentation + "$Key = @(")

                # Sorting an array of hashtables, both on Keys and Values, but the value with key 'Name' always comes first in sorting. For example to properly sort:
                # clusterNodes = @(
                #   @{
                #       Name = 'bdamcln2162'
                #   },
                #   @{
                #       Name = 'bdamcln2163'
                #   }
                #)

                # in the sort-object there is a foreach loop that will produce a string containing keys and values in a sorted manner, with Name always first.
                if ($SortArrayNotforKeys -notcontains $Key -or $value[0] -is [hashtable]) {
                    $Value |
                        Sort-Object -Property {
                            if ($_ -isnot [hashtable]) {
                                $_
                            } elseif ($_.Keys -contains 'Name') {
                                $_.Name
                            }
                        }, {
                            if ($_ -is [hashtable]) {
                                foreach ($sortItemKey in ($_.Keys | Where-Object {$_ -ne 'Name'} | Sort-Object)) {
                                    $sortItemKey + '=' + $_[$sortItemKey]
                                }
                            }
                        } | ForEach-Object {
                            Add-PowerShellDataObject -StringBuilder $StringBuilder -Indentlevel ($Indentlevel + 1) -Value $_ -SortArrayNotforKeys $SortArrayNotforKeys
                        }
                } else {
                    $value | ForEach-Object { Add-PowerShellDataObject -StringBuilder $StringBuilder -Indentlevel ($Indentlevel + 1) -Value $_ -SortArrayNotforKeys $SortArrayNotforKeys }
                }
                $null = $StringBuilder.AppendLine($indentation + ')')
            }
        } else {
            $formattedValue = Format-Value -Value $Value

            if ($Key) {
                $formattedValue = "$Key = " + $formattedValue
            }

            $null = $StringBuilder.AppendLine($indentation + $formattedValue)
        }
    }

    $stringBuilder = New-Object System.Text.StringBuilder

    Add-PowerShellDataObject -StringBuilder $StringBuilder -Value $Data -Indentlevel 0 -SortArrayNotforKeys $SortArrayNotforKeys

    if ($ToString) {
        $stringBuilder.ToString()
    } else {
        if ($PSCmdlet.ShouldProcess(
                $Path,
                "Write PowershellDatafile"
            )) {
            try {
                $stringBuilder.ToString() | Set-Content -LiteralPath $Path -Encoding UTF8 -Force -ErrorAction Stop -NoNewline
                Get-Item -LiteralPath $Path -ErrorAction Stop
            } catch {
                throw "Failed to save information to $Path - $_"
            }
        }
    }
}
