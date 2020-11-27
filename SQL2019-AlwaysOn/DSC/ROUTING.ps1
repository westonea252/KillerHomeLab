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
                $DG = "'"+$using:NextHop+"'"
                $IP = "'"+$using:Subnet+"*"+"'"
                $RouteCheck = Get-NetRoute | Where-Object {$_.NextHop -like $DG}
                IF ($RouteCheck -eq $Null) {
                $Adapter = Get-NetIPAddress | Where-Object {$_.IPAddress -like $IP}
                New-NetRoute -DestinationPrefix "0.0.0.0/0" -InterfaceIndex $Adapter.InterfaceIndex -NextHop $DG
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}