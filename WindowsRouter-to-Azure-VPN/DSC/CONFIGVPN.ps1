configuration CONFIGVPN
{
   param
   (
        [String]$TimeZone,
        [String]$RemoteGatewayIP,
        [String]$LocalAddressPrefix,
        [String]$SharedKey                                 
    )

    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    Node localhost
    {
        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        Script ConfigureRRAS
        {
            SetScript =
            {
                # Configure RRAS
                $Feature = Get-WindowsFeature -Name Routing
                $Installed = $Feature.Installed
                $AddressPrefix = "$using:LocalAddressPrefix"+':100'
                $GatewayIP = "$using:RemoteGatewayIP"

                IF ($Installed -like "False" -or $Null){
                Install-WindowsFeature Routing -IncludeAllSubFeature -IncludeManagementTools
                Install-RemoteAccess -VpnType VpnS2S
                Add-VpnS2SInterface -Protocol IKEv2 -AuthenticationMethod PSKOnly -NumberOfTries 3 -ResponderAuthenticationMethod PSKOnly -Name Azure -Destination "$GatewayIP" -IPv4Subnet @("$AddressPrefix") -SharedSecret "$using:SharedKey"
                Set-VpnServerIPsecConfiguration -EncryptionType MaximumEncryption
                Set-VpnS2Sinterface -Name Azure -InitiateConfigPayload $false -Force
                Connect-VpnS2SInterface -Name Azure
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}