configuration ROUTING
{
   param
   (
        [String]$NextHop,
        [String]$Subnet
    )

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

       Script AddStaticRoute2ndNic
        {
            SetScript =
            {
                $RouteCheck = Get-NetRoute | Where-Object {$_.NextHop -like "$using:NextHop"}
                IF ($RouteCheck -eq $Null) {
                $Adapter = Get-NetIPAddress | Where-Object {$_.IPAddress -like "$using:Subnet"+"*"}
                New-NetRoute -DestinationPrefix "0.0.0.0/0" -InterfaceIndex $Adapter.InterfaceIndex -NextHop "$using:NextHop"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}