configuration APPLYSTIGS
{
   param
   (
        [String]$NetBiosDomain,
        [String]$DC1Name,
        [String]$BaseDN,
        [String]$SVROUPath,
        [String]$SVR2016OUPath,
        [String]$WKOUPath,
        [String]$WK10OUPath,


        [String]$DefaultDomainGPOURL,
        [String]$SVRDCBaselineGPOURL,
        [String]$SVR2016DCBaselineGPOURL,
        [String]$SVRDCBaselineTimeGPOURL,
        [String]$SVRBaselineGPOURL,
        [String]$SVR2016BaselineGPOURL,
        [String]$SVRDisableSSLGPOURL,
        [String]$WKSBaselineGPOURL,
        [String]$WKSWIN10BaselineGPOURL,
        [String]$WKSDisableSSLGPOURL,
        [String]$IEEnhancedGPOURL,
        [String]$PolicyDefinitionsURL,

        [String]$DefaultDomainGPOGUID,
        [String]$SVRDCBaselineGPOGUID,
        [String]$SVR2016DCBaselineGPOGUID,
        [String]$SVRDCBaselineTimeGPOGUID,
        [String]$SVRBaselineGPOGUID,
        [String]$SVR2016BaselineGPOGUID,
        [String]$SVRDisableSSLGPOGUID,
        [String]$WKSBaselineGPOGUID,
        [String]$WKSWIN10BaselineGPOGUID,
        [String]$WKSDisableSSLGPOGUID,
        [String]$IEEnhancedGPOGUID,
        [String]$PolicyDefinitionsGUID,

        [String]$DefaultDomainGPOName,
        [String]$SVRDCBaselineGPOName,
        [String]$SVR2016DCBaselineGPOName,
        [String]$SVRDCBaselineTimeGPOName,
        [String]$SVRBaselineGPOName,
        [String]$SVR2016BaselineGPOName,
        [String]$SVRDisableSSLGPOName,
        [String]$WKSBaselineGPOName,
        [String]$WKSWIN10BaselineGPOName,
        [String]$WKSDisableSSLGPOName,
        [String]$IEEnhancedGPOName,
        [String]$PolicyDefinitionsName,
        
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

        ADGroup 2016_ServersGroup
        {
            Ensure = 'Present'
            GroupName = '2016_Servers'
            Path       = "OU=Admin,OU=Groups,$BaseDN"
        }

        ADGroup 2016_DCsGroup
        {
            Ensure = 'Present'
            GroupName = '2016_DCs'
            Path       = "OU=Admin,OU=Groups,$BaseDN"
        }

        File STIGS
        {
            Type = 'Directory'
            DestinationPath = 'C:\STIGS'
            Ensure = "Present"
        }

        xRemoteFile DefaultDomainGPO
        {
            DestinationPath = "C:\STIGS\$DefaultDomainGPOName.zip"
            Uri             = $DefaultDomainGPO
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64', '[File]STIGS'
        }

        xRemoteFile SVRDCBaselineGPO
        {
            DestinationPath = "C:\STIGS\$SVRDCBaselineGPOName.zip"
            Uri             = $SVRDCBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]DefaultDomainGPO'
        }

        xRemoteFile SVR2016DCBaselineGPO
        {
            DestinationPath = "C:\STIGS\$SVR2016DCBaselineGPOName.zip"
            Uri             = $SVR2016DCBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]SVRDCBaselineGPO'
        }

        xRemoteFile SVRDCBaselineTimeGPO
        {
            DestinationPath = "C:\STIGS\$SVRDCBaselineTimeGPOName.zip"
            Uri             = $SVRDCBaselineTimeGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]SVR2016DCBaselineGPO'
        }

        xRemoteFile SVRBaselineGPO
        {
            DestinationPath = "C:\STIGS\$SVRBaselineGPOName.zip"
            Uri             = $SVRBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]SVRDCBaselineTimeGPO'
        }

        xRemoteFile SVR2016BaselineGPO
        {
            DestinationPath = "C:\STIGS\$SVR2016BaselineGPOName.zip"
            Uri             = $SVR2016BaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]SVRBaselineGPO'
        }

        xRemoteFile SVRDisableSSLGPO
        {
            DestinationPath = "C:\STIGS\$SVRDisableSSLGPOName.zip"
            Uri             = $SVRDisableSSLGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]SVR2016BaselineGPO'
        }

        xRemoteFile WKSBaselineGPO
        {
            DestinationPath = "C:\STIGS\$WKSBaselineGPOName.zip"
            Uri             = $WKSBaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]SVRDisableSSLGPO'
        }

        xRemoteFile WKSWIN10BaselineGPO
        {
            DestinationPath = "C:\STIGS\$WKSWIN10BaselineGPOName.zip"
            Uri             = $WKSWIN10BaselineGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]WKSBaselineGPO'
        }

        xRemoteFile WKSDisableSSLGPO
        {
            DestinationPath = "C:\STIGS\$WKSDisableSSLGPOName.zip"
            Uri             = $WKSDisableSSLGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]WKSWIN10BaselineGPO'
        }

        xRemoteFile IEEnhancedGPOURL
        {
            DestinationPath = "C:\STIGS\$IEEnhancedGPOName.zip"
            Uri             = $IEEnhancedGPOURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]WKSDisableSSLGPO'
        }

        xRemoteFile PolicyDefinitions
        {
            DestinationPath = "C:\STIGS\$PolicyDefinitionsName.zip"
            Uri             = $PolicyDefinitionsURL
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]IEEnhancedGPOURL'
        }

        Script DownloadSTIGS
        {
            SetScript =
            {
                # Create Security Filtering Groups and Populate Them
                $dc2016group = Get-ADGroup -Filter * | Where-Object {$_.Name -like "2016_DCs"}
                IF ($dc2016group -eq $null) {New-ADGroup -Name "2016_DCs" -GroupScope Global}
                $dc2016group = Get-ADGroup -Filter * | Where-Object {$_.Name -like "2016_DCs"}
                IF ($dc2016group -ne $null) {Add-ADGroupMember -Identity "2016_DCs" -Members "$using:DC1Name" }

                # UnCompress Default Domain Policy
                $DefaultDomainGPOPath = Get-Item -Path "C:\STIGS\$using:DefaultDomainGPOName" -ErrorAction 0
                IF ($DefaultDomainGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:DefaultDomainGPOName.zip" -DestinationPath "C:\STIGS\$using:DefaultDomainGPOName"
                }

                # UnCompress DC SVR Baseline
                $SVRDCBaselineGPOPath = Get-Item -Path "C:\STIGS\$using:SVRDCBaselineGPOName" -ErrorAction 0
                IF ($SVRDCBaselineGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:SVRDCBaselineGPOName.zip" -DestinationPath "C:\STIGS\$using:SVRDCBaselineGPOName"
                }

                # UnCompress DC SVR 2016 Baseline
                $SVR2016DCBaselineGPOPath = Get-Item -Path "C:\STIGS\$using:SVR2016DCBaselineGPOName" -ErrorAction 0
                IF ($SVR2016DCBaselineGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:SVR2016DCBaselineGPOName.zip" -DestinationPath "C:\STIGS\$using:SVR2016DCBaselineGPOName"
                }

                # UnCompress DC SVR Baseline TimeSource
                $SVRDCBaselineTimeGPOPath = Get-Item -Path "C:\STIGS\$using:SVRDCBaselineTimeGPOName" -ErrorAction 0
                IF ($SVRDCBaselineTimeGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:SVRDCBaselineTimeGPOName.zip" -DestinationPath "C:\STIGS\$using:SVRDCBaselineTimeGPOName"
                }

                # UnCompress SVR Baseline
                $SVRBaselineGPOPath = Get-Item -Path "C:\STIGS\$using:SVRBaselineGPOName" -ErrorAction 0
                IF ($SVRBaselineGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:SVRBaselineGPOName.zip" -DestinationPath "C:\STIGS\$using:SVRBaselineGPOName"
                }

                # UnCompress SVR 2016 Baseline
                $SVR2016BaselineGPOPath = Get-Item -Path "C:\STIGS\$using:SVR2016BaselinGPOName" -ErrorAction 0
                IF ($SVR2016BaselineGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:SVR2016BaselinGPOName.zip" -DestinationPath "C:\STIGS\$using:SVR2016BaselinGPOName"
                }

                # UnCompress SVR TLS
                $SVRDisableSSLGPOPath = Get-Item -Path "C:\STIGS\$using:SVRDisableSSLGPOName" -ErrorAction 0
                IF ($SVRDisableSSLGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:SVRDisableSSLGPOName.zip" -DestinationPath "C:\STIGS\$using:SVRDisableSSLGPOName"
                }

                # UnCompress WKS Baseline
                $WKSBaselineGPOPath = Get-Item -Path "C:\STIGS\$using:WKSBaselineGPOName" -ErrorAction 0
                IF ($WKSBaselineGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:WKSBaselineGPOName.zip" -DestinationPath "C:\STIGS\$using:WKSBaselineGPOName"
                }

                # UnCompress WKS 10 Baseline
                $WKSWIN10BaselineGPOPath = Get-Item -Path "C:\STIGS\$using:WKSWIN10BaselineGPOName" -ErrorAction 0
                IF ($WKSWIN10BaselineGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:WKSWIN10BaselineGPOName.zip" -DestinationPath "C:\STIGS\$using:WKSWIN10BaselineGPOName"
                }

                # UnCompress WKS TLS
                $WKSDisableSSLGPOPath = Get-Item -Path "C:\STIGS\$using:WKSDisableSSLGPOName" -ErrorAction 0
                IF ($WKSDisableSSLGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:WKSDisableSSLGPOName" -DestinationPath "C:\STIGS\$using:WKSDisableSSLGPOName"
                }

                # UnCompress IE11 Enhanced Testing
                $IEEnhancedGPOPath = Get-Item -Path "C:\STIGS\$using:IEEnhancedGPOName" -ErrorAction 0
                IF ($DefaultDomainGPOPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:IEEnhancedGPOName.zip" -DestinationPath "C:\STIGS\$using:IEEnhancedGPOName"
                }

                # UnCompress Policy Definitions
                $PolicyDefinitionsPath = Get-Item -Path "N:\SYSVOL\domain\Policies\PolicyDefinitions" -ErrorAction
                IF ($PolicyDefinitionsPath -eq $Null) {
                Expand-Archive -Path "C:\STIGS\$using:PolicyDefinitionsName.zip" -DestinationPath "N:\SYSVOL\domain\Policies"
                }

                # Load Default GPO
                $DefaultDomainPolicy = Get-GPO -Name "$using:DefaultDomainGPOName" -ErrorAction 0
                IF ($DefaultDomainPolicy -eq $null) {
                Import-GPO -BackupId "$using:DefaultDomainGPOGUID" -TargetName "$using:DefaultDomainGPOName" -path "C:\STIGS\$using:DefaultDomainGPOName"
                }

                # Create and Link DC SVR Baseline GPO
                $SVRDCBaselinePolicy = Get-GPO -Name "$using:SVRDCBaselineGPOName" -ErrorAction 0
                IF ($SVRDCBaselinePolicy -eq $null) {
                New-Gpo -Name "$using:SVRDCBaselineGPOName" | New-GPLink -Target "OU=Domain Controllers,$using:BaseDN"
                Set-GPLink -Name "$using:SVRDCBaselineGPOName" -Target "OU=Domain Controllers,$using:BaseDN" -Order 3
                Import-GPO -BackupId "$using:SVRDCBaselineGPOGUID" -TargetName "$using:SVRDCBaselineGPOName" -Path "C:\STIGS\$using:SVRDCBaselineGPOName"
                Set-GPPermission -Name "$using:SVRDCBaselineGPOName" -TargetName "Authenticated Users" -Replace -TargetType Group -PermissionLevel GPORead
                Set-GPPermission -Name "$using:SVRDCBaselineGPOName" -TargetName "2016_DCs" -Replace -TargetType Group -PermissionLevel GPOApply
                }

                # Create and Link DC SVR 2016 Baseline GPO
                $SVR2016DCBaselinePolicy = Get-GPO -Name "$using:SVR2016DCBaselineGPOName" -ErrorAction 0
                IF ($SVR2016DCBaselinePolicy -eq $null) {
                New-Gpo -Name "$using:SVR2016DCBaselineGPOName" | New-GPLink -Target "OU=Domain Controllers,$using:BaseDN"
                Set-GPLink -Name "$using:SVR2016DCBaselineGPOName" -Target "OU=Domain Controllers,$using:BaseDN" -Order 3
                Import-GPO -BackupId "$using:SVR2016DCBaselineGPOGUID" -TargetName "$using:SVR2016DCBaselineGPOName" -Path "C:\STIGS\$using:SVR2016DCBaselineGPOName"
                Set-GPPermission -Name "$using:SVR2016DCBaselineGPOName" -TargetName "Authenticated Users" -Replace -TargetType Group -PermissionLevel GPORead
                Set-GPPermission -Name "$using:SVR2016DCBaselineGPOName" -TargetName "2016_DCs" -Replace -TargetType Group -PermissionLevel GPOApply
                }

                # Create and Link DC SVR Baseline Time GPO
                $SVRDCBaselineTimePolicy = Get-GPO -Name "$using:SVRDCBaselineTimeGPOName" -ErrorAction 0
                IF ($SVRDCBaselineTimePolicy -eq $null) {
                New-Gpo -Name "$using:SVRDCBaselineTimeGPOName" | New-GPLink -Target "OU=Domain Controllers,$using:BaseDN"
                Set-GPLink -Name "$using:SVRDCBaselineTimeGPOName" -Target "OU=Domain Controllers,$using:BaseDN" -Order 1
                Import-GPO -BackupId "$using:SVRDCBaselineTimeGPOGUID" -TargetName "$using:SVRDCBaselineTimeGPOName" -Path "C:\STIGS\$using:SVRDCBaselineTimeGPOName"
                }

                # Create and Link SVR Baseline GPO
                $SVRBaselinePolicy = Get-GPO -Name "$using:SVRBaselineGPOName" -ErrorAction 0
                IF ($SVRBaselinePolicy -eq $null) {
                New-Gpo -Name "$using:SVRBaselineGPOName" | New-GPLink -Target "$using:SVR8OUPath"
                Set-GPLink -Name "$using:SVRBaselineGPOName" -Target "$using:SVROUPath" -Order 2
                Import-GPO -BackupId "$using:SVRBaselineGPOGUID" -TargetName "$using:SVRBaselineGPOName" -Path "C:\STIGS\$using:SVRBaselineGPOName"
                Set-GPPermission -Name "$using:SVRBaselineGPOName" -TargetName "Authenticated Users" -Replace -TargetType Group -PermissionLevel GPORead
                Set-GPPermission -Name "$using:SVRBaselineGPOName" -TargetName "2016_Servers" -Replace -TargetType Group -PermissionLevel GPOApply
                }

                # Create and Link SVR 2016 Baseline GPO
                $SVR2016BaselinePolicy = Get-GPO -Name "$using:SVR2016BaselinGPOName" -ErrorAction 0
                IF ($SVR2016BaselinePolicy -eq $null) {
                New-Gpo -Name "$using:SVR2016BaselinGPOName" | New-GPLink -Target "$using:SVR2016OUPath"
                Set-GPLink -Name "$using:SVR2016BaselinGPOName" -Target "$using:SVR2016OUPath" -Order 1
                Import-GPO -BackupId "$using:SVR2016BaselinGPOGUID" -TargetName "$using:SVR2016BaselinGPOName" -Path "C:\STIGS\$using:SVR2016BaselinGPOName"
                Set-GPPermission -Name "$using:SVR2016BaselinGPOName" -TargetName "Authenticated Users" -Replace -TargetType Group -PermissionLevel GPORead
                Set-GPPermission -Name "$using:SVR2016BaselinGPOName" -TargetName "2016_Servers" -Replace -TargetType Group -PermissionLevel GPOApply
                }
                
                # Create and Link IE Enhanced GPO
                $IEEnhancedPolicy = Get-GPO -Name "$using:IEEnhancedGPOName" -ErrorAction 0
                IF ($IEEnhancedPolicy -eq $null) {
                New-Gpo -Name "$using:IEEnhancedGPOName" | New-GPLink -Target "$using:WKOUPath"
                Set-GPLink -Name "$using:IEEnhancedGPOName" -Target "$using:WKOUPath" -Order 3
                Import-GPO -BackupId "$using:IEEnhancedGPOGUID" -TargetName "$using:IEEnhancedGPOName" -Path "C:\STIGS\$using:IEEnhancedGPOName"
                }

                # Create and Link SVR Baseline GPO
                $SVR2016BaselinePolicy = Get-GPO -Name $SVR2016BaselineGPOPath -ErrorAction 0
                IF ($SVR2016BaselinePolicy -eq $null) {
                New-Gpo -Name "$using:SVRBaselineGPOName" | New-GPLink -Target "$using:SVR2016OUPath"
                Set-GPLink -Name "$using:SVRBaselineGPOName" -Target "$using:SVR2016OUPath" -Order 2
                Import-GPO -BackupId "$using:SVRBaselineGPOGUID" -TargetName "$using:SVRBaselineGPOName" -Path "C:\STIGS\$using:SVRBaselineGPOName"
                Set-GPPermission -Name "$using:SVRBaselineGPOName" -TargetName "Authenticated Users" -Replace -TargetType Group -PermissionLevel GPORead
                Set-GPPermission -Name "$using:SVRBaselineGPOName" -TargetName "2016_Servers" -Replace -TargetType Group -PermissionLevel GPOApply
                }

# Create GPOs
$srv2016 = Get-GPO -Name "$(SVR2016Baselinev3)" -ErrorAction 0
$srvtls = Get-GPO -Name "$(SVRDisableSSLTLSExceptTLS12TEST)" -ErrorAction 0

$file2 = Get-Item -Path "C:\MachineConfig\$(SVR2016Baselinev3).zip" -ErrorAction 0
$file3 = Get-Item -Path "C:\MachineConfig\$(SVRDisableSSLTLSExceptTLS12TEST).zip" -ErrorAction 0


# Link GPO's and set Order
IF ($srv2016 -eq $null) {New-Gpo -Name "$(SVR2016Baselinev3)" | New-GPLink -Target "OU=Servers2016,OU=Servers,DC=$(Dom1ID),DC=$(Dom1IDRoot),DC=com"}
IF ($srvtls -eq $null) {New-Gpo -Name "$(SVRDisableSSLTLSExceptTLS12TEST)" | New-GPLink -Target "OU=Servers,DC=$(Dom1ID),DC=$(Dom1IDRoot),DC=com"}

Set-GPLink -Name "$(SVRDisableSSLTLSExceptTLS12TEST)" -Target "OU=Servers,DC=$(Dom1ID),DC=$(Dom1IDRoot),DC=com" -Order 1
Set-GPLink -Name "$(SVR2016Baselinev3)" -Target "OU=Servers2016,OU=Servers,DC=$(Dom1ID),DC=$(Dom1IDRoot),DC=com" -Order 1

# Import GPOs
IF ($file2 -ne $null) {Import-GPO -BackupId 27764575-1F9E-4962-A039-EC6B650BEF43 -TargetName "$(SVR2016Baselinev3)" -path "C:\MachineConfig\$(SVR2016Baselinev3)"}
IF ($file3 -ne $null) {Import-GPO -BackupId 9BE6002A-4B9F-4FB6-8CB6-DAA6BEF87AAD -TargetName "$(SVRDisableSSLTLSExceptTLS12TEST)" -path "C:\MachineConfig\$(SVRDisableSSLTLSExceptTLS12TEST)"}

# Remove Apply Rights from GPO's for Authenticated Users
Set-GPPermission -Name "$(SVR2016Baselinev3)" -TargetName "Authenticated Users" -Replace -TargetType Group -PermissionLevel GPORead
Set-GPPermission -Name "$(SVRDisableSSLTLSExceptTLS12TEST)" -TargetName "Authenticated Users" -Replace -TargetType Group -PermissionLevel GPORead

# Apply 2016 Server Security Filtering
Set-GPPermission -Name "$(SVRBaselinev3)" -TargetName "$(Dom1ID)_2016_GPO" -Replace -TargetType Group -PermissionLevel GPOApply
Set-GPPermission -Name "$(SVR2016Baselinev3)" -TargetName "$(Dom1ID)_2016_GPO" -Replace -TargetType Group -PermissionLevel GPOApply
Set-GPPermission -Name "$(SVRDisableSSLTLSExceptTLS12TEST)" -TargetName "$(Dom1ID)_2016_GPO" -Replace -TargetType Group -PermissionLevel GPOApply

            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
            DependsOn = '[xRemoteFile]PolicyDefinitions'
        }
    }
}