configuration CONFIGVPN1
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
        File ConfigureRRAS
        {
            Type = 'Directory'
            DestinationPath = 'C:\ConfigureRRAS'
            Ensure = "Present"
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        Script ConfigureRRAS
        {
            SetScript =
            {
                # Create Credentials
                $Load = "$using:AdminCreds"
                $Username = $AdminCreds.GetNetworkCredential().Username
                $Password = $AdminCreds.GetNetworkCredential().Password
                $FalseValue = '$False'
                
                # Create ConfigureRRAS Script
                Set-Content -Path C:\ConfigureRRAS\SetupRRAS.ps1 -Value "Install-RemoteAccess -VpnType VpnS2S"
                Add-Content -Path C:\ConfigureRRAS\SetupRRAS.ps1 -Value "Add-VpnS2SInterface -Protocol IKEv2 -AuthenticationMethod PSKOnly -NumberOfTries 3 -ResponderAuthenticationMethod PSKOnly -Name Azure -Destination $using:RemoteGatewayIP -IPv4Subnet $using:IPv4Subnet -SharedSecret $using:SharedKey"
                Add-Content -Path C:\ConfigureRRAS\SetupRRAS.ps1 -Value "Set-VpnServerIPsecConfiguration -EncryptionType MaximumEncryption"
                Add-Content -Path C:\ConfigureRRAS\SetupRRAS.ps1 -Value "Set-VpnS2Sinterface -Name Azure -InitiateConfigPayload $FalseValue -Force"
                Add-Content -Path C:\ConfigureRRAS\SetupRRAS.ps1 -Value "Connect-VpnS2SInterface -Name Azure"

                # Create Scheduled Task
                $scheduledtask = Get-ScheduledTask "Configure RRAS" -ErrorAction 0
                IF ($scheduledtask -eq $null) {
                $action = New-ScheduledTaskAction -Execute Powershell -Argument '.\SetupRRAS.ps1' -WorkingDirectory 'C:\ConfigureRRAS'
                Register-ScheduledTask -Action $action -TaskName "Configure RRAS" -Description "Configure RRAS" -User $Username -Password $Password
                Start-ScheduledTask "Configure RRAS"
                }      
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]ConfigureRRAS'
            Credential =  = $Admincreds
        }
    }
}