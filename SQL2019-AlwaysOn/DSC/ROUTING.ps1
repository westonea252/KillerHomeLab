configuration ROUTING
{
   param
   (
        [String]$NextHop
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
                $RouteCheck = Get-NetRoute | Where-Object {$_.NextHop -like $DG}
                IF ($RouteCheck -eq $Null) {
                $Adapter = Get-NetIPAddress | Where-Object {$_.IPAddress -like $DG}
                New-NetRoute -DestinationPrefix "0.0.0.0/0" -InterfaceIndex $Adapter.InterfaceIndex -NextHop $DG
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}