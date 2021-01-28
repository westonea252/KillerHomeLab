configuration APPLYSTIGS
{
   param
   (
        [String]$NetBiosDomain,
        [String]$DefaultDomainGPOURL,
        [String]$IEEnhancedGPOURL,
        [String]$PolicyDefinitionsURL,
        [String]$SVR2016BaselinGPOURL,
        [String]$SVR2016DCBaselineGPOURL,
        [String]$SVRBaselineGPOURL,
        [String]$SVRDCBaselineGPOURL,
        [String]$SVCDCBaselineTimeGPOURL,
        [String]$SVRDisableSSLGPOURL,
        [String]$WKBaselineGPOURL,
        [String]$WKDisableSSLGPOURL,
        [String]$WKWIN10BaselineGPOURL,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module ActiveDirectoryDsc
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        Registry SchUseStrongCrypto
        {
            Key                         = 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        Registry SchUseStrongCrypto64
        {
            Key                         = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        File STIGS
        {
            Type = 'Directory'
            DestinationPath = 'C:\STIGS'
            Ensure = "Present"
        }

        xRemoteFile DefaultDomainGPO
        {
            DestinationPath = "C:\STIGS\Default Domain Policy.zip"
            Uri             = $DefaultDomainGPO
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile IEEnhancedGPOURL
        {
            DestinationPath = "C:\STIGS\IE11_Enhanced Testing.zip"
            Uri             = $IEEnhancedGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile PolicyDefinitions
        {
            DestinationPath = "C:\STIGS\PolicyDefinitions.zip"
            Uri             = $PolicyDefinitionsURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile SVR2016BaselinGPO
        {
            DestinationPath = "C:\STIGS\SVR-2016-Baseline-v3.zip"
            Uri             = $SVR2016BaselinGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile SVR2016DCBaselineGPO
        {
            DestinationPath = "C:\STIGS\SVR-2016-DC-Baseline-v2.zip"
            Uri             = $SVR2016DCBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile SVRBaselineGPO
        {
            DestinationPath = "C:\STIGS\SVR-Baseline-v3.zip"
            Uri             = $SVRBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile SVRDCBaselineGPO
        {
            DestinationPath = "C:\STIGS\SVR-DC-Baseline-v3.zip"
            Uri             = $SVRDCBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile SVCDCBaselineTimeGPO
        {
            DestinationPath = "C:\STIGS\SVR-DC-Baseline-WindowsTimeSource-v1.zip"
            Uri             = $SVCDCBaselineTimeGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile SVRDisableSSLGPO
        {
            DestinationPath = "C:\STIGS\SVR-Disable-SSL-TLS(Except-TLS-1.2)-TEST.zip"
            Uri             = $SVRDisableSSLGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile WKBaselineGPO
        {
            DestinationPath = "C:\STIGS\WKS-Baseline-v3.zip"
            Uri             = $WKBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile WKDisableSSLGPO
        {
            DestinationPath = "C:\STIGS\WKS-Disable-SSL-TLS(Except-TLS-1.2)-TEST.zip"
            Uri             = $WKDisableSSLGPO
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile WKWIN10BaselineGPO
        {
            DestinationPath = "C:\STIGS\WKS-WIN10-Baseline-v3.zip"
            Uri             = $WKWIN10BaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        Script ApplyDomainSTIGS
        {
            SetScript =
            {
                "C:\STIGS\Default Domain Policy.zip"
                "C:\STIGS\IE11_Enhanced Testing.zip"
                "C:\STIGS\PolicyDefinitions.zip"
                "C:\STIGS\SVR-2016-DC-Baseline-v2.zip"

                # UnCompress Default Domain Policy
                $DefaultDomainPolicyPath = Get-Item -Path "C:\STIGS\Default Domain Policy" -ErrorAction 0
                IF ($DefaultDomainPolicyPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\Default Domain Policy.zip" -DestinationPath "C:\STIGS\Default Domain Policy"
                }

                # UnCompress IE11 Enhanced Testing
                $IEEnhancedPolicyPath = Get-Item -Path "C:\STIGS\Default Domain Policy" -ErrorAction 0
                IF ($DefaultDomainPolicyPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\Default Domain Policy.zip" -DestinationPath "C:\STIGS\Default Domain Policy"
                }

                # UnCompress Policy Definitions
                $PolicyDefinitionsPath = Get-Item -Path "N:\SYSVOL\domain\Policies\PolicyDefinitions" -ErrorAction
                IF ($PolicyDefinitionsPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\PolicyDefinitions.zip" -DestinationPath "N:\SYSVOL\domain\Policies"
                }

# Create GPOs
$domain = Get-GPO -Name "$(DefaultDomainPolicy)" -ErrorAction 0
$execpolicy = Get-GPO -Name "$(PowerShellExecutionPolicy)" -ErrorAction 0

# Link GPO's and set Order

IF ($execpolicy -eq $null) {New-Gpo -Name "$(PowerShellExecutionPolicy)" | New-GPLink -Target "DC=$(Dom1ID),DC=$(Dom1IDRoot),DC=com"}

Set-GPLink -Name "$(PowerShellExecutionPolicy)" -Target "DC=$(Dom1ID),DC=$(Dom1IDRoot),DC=com" -Order 2

# Import GPOs
IF ($file1 -eq $null) {Import-GPO -BackupId 079C9640-8D6E-40F1-8618-1A026A2E5D76 -TargetName "$(DefaultDomainPolicy)" -path "C:\MachineConfig\$(DefaultDomainPolicy)"}
IF ($file3 -eq $null) {Import-GPO -BackupId EC04DF04-A647-4A3E-9247-51B4CB137F5F -TargetName "$(PowerShellExecutionPolicy)" -path "C:\MachineConfig\$(PowerShellExecutionPolicy)"}

            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }

        Script CreateCATemplates
        {
            SetScript =
            {
                $Load = "$using:DomainCreds"
                $Domain = $DomainCreds.GetNetworkCredential().Domain
                $Username = $DomainCreds.GetNetworkCredential().UserName
                $Password = $DomainCreds.GetNetworkCredential().Password 

                # Create CA Templates
                $scheduledtask = Get-ScheduledTask "Create CA Templates" -ErrorAction 0
                $action = New-ScheduledTaskAction -Execute Powershell -Argument '.\Create_CA_Templates.ps1' -WorkingDirectory 'C:\CertEnroll'
                IF ($scheduledtask -eq $null) {
                Register-ScheduledTask -Action $action -TaskName "Create CA Templates" -Description "Create Web Server & OCSP CA Templates" -User $Domain\$Username -Password $Password
                Start-ScheduledTask "Create CA Templates"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]ConfigureIssuingCA'
        }
    }
}