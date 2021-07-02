configuration CONFIGVPN
{
   param
   (
        [String]$TimeZone,
        [String]$RemoteGatewayIP,
        [String]$IPv4Subnet,
        [String]$SharedKey,
        [System.Management.Automation.PSCredential]$Admincreds                                                                          
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
                $RemoteAccess = Get-RemoteAccess
                $InstallStatus = $RemoteAccess.VpnS2SStatus
                $FalseValue = '$False'

                IF ($InstallStatus -like "Uninstalled"){
                Install-RemoteAccess -VpnType VpnS2S
                Add-VpnS2SInterface -Protocol IKEv2 -AuthenticationMethod PSKOnly -NumberOfTries 3 -ResponderAuthenticationMethod PSKOnly -Name Azure -Destination $using:RemoteGatewayIP -IPv4Subnet $using:IPv4Subnet -SharedSecret "$using:SharedKey"
                Set-VpnServerIPsecConfiguration -EncryptionType MaximumEncryption
                Set-VpnS2Sinterface -Name Azure -InitiateConfigPayload $FalseValue -Force
                Connect-VpnS2SInterface -Name Azure
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $Admincreds
        }
    }
}