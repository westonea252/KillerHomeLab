configuration CONFIGVPN1
{
   param
   (
        [String]$ComputerName,
        [String]$TimeZone,
        [String]$RemoteGatewayIP,
        [String]$IPv4Subnet,
        [String]$SharedKey,
        [System.Management.Automation.PSCredential]$Admincreds                                  
    )

    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    [System.Management.Automation.PSCredential ]$LocalCreds = New-Object System.Management.Automation.PSCredential ("${ComputerName}\$($AdminCreds.UserName)", $AdminCreds.Password)

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
                $Load = "$using:LocalCreds"
                $Username = $LocalCreds.GetNetworkCredential().Username
                $Password = $LocalCreds.GetNetworkCredential().Password
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

                # Allow Remote Copy
                $allowlegacy = get-itemproperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters" -Name "ModernStackEnabled" -ErrorAction 0
                IF ($allowlegacy.ModernStackEnabled -ne 0) {New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters\" -Name "ModernStackEnabled" -Value 0 -Force}
                }      
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]ConfigureRRAS'
        }

        Script StartTask
        {
            SetScript =
            {   

                # Create Scheduled Task
                $scheduledtaskInfo = Get-ScheduledTaskInfo -TaskName "Configure RRAS" -ErrorAction 0
                $CurrentDate = Get-Date
                $LastRunTime = $scheduledtaskInfo.LastRunTime
                IF ($CurrentDate -gt $LastRunTime) {
                Start-ScheduledTask "Configure RRAS"
                }      
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]ConfigureRRAS'
            Credential = $LocalCreds
        }

    }
}