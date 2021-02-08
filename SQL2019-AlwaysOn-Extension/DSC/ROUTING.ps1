configuration ROUTING
{
   param
   (
        [String]$NextHop,
        [String]$ManagementSubnet,
        [String]$DataSubnet
    )

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script UnregisterNIC
        {
            SetScript =
            {
                # UnRegister NIC 2
                $ManagementAdapter = Get-NetIPAddress | Where-Object {$_.IPAddress -like "$using:ManagementSubnet"+"*"}
                Set-DnsClient -InterfaceAlias $ManagementAdapter.InterfaceAlias -RegisterThisConnectionsAddress:$False                
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

       Script AddStaticRoute2ndNic
        {
            SetScript =
            {
                $RouteCheck = Get-NetRoute | Where-Object {$_.NextHop -like "$using:NextHop"}
                IF ($RouteCheck -eq $Null) {
                $DataAdapter = Get-NetIPAddress | Where-Object {$_.IPAddress -like "$using:DataSubnet"+"*"}
                New-NetRoute -DestinationPrefix "0.0.0.0/0" -InterfaceIndex $DataAdapter.InterfaceIndex -NextHop "$using:NextHop"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}