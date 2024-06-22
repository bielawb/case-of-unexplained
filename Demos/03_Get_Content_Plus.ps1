# Problem: Get-Content returns more than just a simple string...
$value = Get-Content -Path .\SampleFiles\my_var_value.txt

# When looking at it on the screen - nothing unexpected...
$value
"$value"

# Assign the value to the JSON - we get all the meta information from disk...
@{
    value = $value
} | ConvertTo-Json

# We can see these properties when using Get-Member
$value | Get-Member -MemberType NoteProperty


# Solution - make sure we get clean string...
@{
    value = [String]$value
} | ConvertTo-Json

@{
    value = "$value"
} | ConvertTo-Json

@{
    value = $value.ToString()
} | ConvertTo-Json

# Pick your poison!