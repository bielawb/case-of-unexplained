# Problem: automatic variables can often be used, but can cause collisions/ issues!
function Set-FCPort {
    param (
        $Switch,
        $Port,
        $ConnectedDevice,
        $ConnectedPort,
        [ValidateSet(
                'Enabled',
                'Disabled'
        )]
        $State
    )

    switch ($State) {
        Enabled {
            [PSCustomObject]@{
                Switch = $Switch
                Port = $Port
                Description = '{0}_{1}' -f $ConnectedDevice, $ConnectedPort
            }
        }
        Disabled {
            [PSCustomObject]@{
                Switch = $Switch
                Port = $Port
                Description = 'port{0}' -f $Port
            }
        }
    }
}

# Running function - we get type of automatic variable $switch...
Set-FCPort -Switch psconf_fc_01 -Port 20 -State Enabled -ConnectedDevice psconf_esxi_01 -ConnectedPort P1

# How to avoid?
Get-Help about_automatic_variables