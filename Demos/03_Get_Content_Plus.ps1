$value = Get-Content -Path .\SampleFiles\my_var_value.txt
@{
    value = $value
} | ConvertTo-Json

$value | Get-Member -MemberType NoteProperty