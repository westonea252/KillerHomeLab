configuration PREPAREEXCHANGE10
{
   param
   (
        [String]$ExchangeSASUrl,     
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xStorage # Used by Disk
    Import-DscResource -Module xPendingReboot # Used for Reboots

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script DismountISO
        {
      	    SetScript = {
                Dismount-DiskImage "S:\ExchangeInstall\Exchange2010.iso" -ErrorAction 0
            }
            GetScript =  { @{} }
            TestScript = { $false }
        }

        #Exchange Prereqs
        WindowsFeature NET-HTTP-Activation
        {
            Ensure = 'Present'
            Name = 'NET-HTTP-Activation'
        }

        WindowsFeature NET-Framework-Features
        {
            Ensure = 'Present'
            Name = 'NET-Framework-Features'
        }
        
        WindowsFeature RPC-over-HTTP-proxy
        {
            Ensure = 'Present'
            Name = 'RPC-over-HTTP-proxy'
        }
        
        WindowsFeature RSAT-Clustering
        {
            Ensure = 'Present'
            Name = 'RSAT-Clustering'
        }
        
        WindowsFeature WAS-Process-Model
        {
            Ensure = 'Present'
            Name = 'WAS-Process-Model'
        }
        
        WindowsFeature Web-Asp-Net
        {
            Ensure = 'Present'
            Name = 'Web-Asp-Net'
        }
        
        WindowsFeature Web-Basic-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Basic-Auth'
        }
        
        WindowsFeature Web-Client-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Client-Auth'
        }
        
        WindowsFeature Web-Digest-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Digest-Auth'
        }
        
        WindowsFeature Web-Dir-Browsing
        {
            Ensure = 'Present'
            Name = 'Web-Dir-Browsing'
        }
        
        WindowsFeature Web-Dyn-Compression
        {
            Ensure = 'Present'
            Name = 'Web-Dyn-Compression'
        }
        
        WindowsFeature Web-Http-Errors
        {
            Ensure = 'Present'
            Name = 'Web-Http-Errors'
        }
        
        WindowsFeature Web-Http-Logging
        {
            Ensure = 'Present'
            Name = 'Web-Http-Logging'
        }
        
        WindowsFeature Web-Http-Redirect
        {
            Ensure = 'Present'
            Name = 'Web-Http-Redirect'
        }
        
        WindowsFeature Web-Http-Tracing
        {
            Ensure = 'Present'
            Name = 'Web-Http-Tracing'
        }
        
        WindowsFeature Web-ISAPI-Ext
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Ext'
        }
        
        WindowsFeature Web-ISAPI-Filter
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Filter'
        }
        
        WindowsFeature Web-Lgcy-Mgmt-Console
        {
            Ensure = 'Present'
            Name = 'Web-Lgcy-Mgmt-Console'
        }
        
        WindowsFeature Web-Metabase
        {
            Ensure = 'Present'
            Name = 'Web-Metabase'
        }
        
        WindowsFeature Web-Mgmt-Console
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Console'
        }
        
        
        WindowsFeature Web-Net-Ext
        {
            Ensure = 'Present'
            Name = 'Web-Net-Ext'
        }
        
        WindowsFeature Web-Request-Monitor
        {
            Ensure = 'Present'
            Name = 'Web-Request-Monitor'
        }
        
        WindowsFeature Web-Server
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
        
        WindowsFeature Web-Static-Content
        {
            Ensure = 'Present'
            Name = 'Web-Static-Content'
        }
        
        WindowsFeature Web-Windows-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Windows-Auth'
        }
        
        WindowsFeature Web-WMI
        {
            Ensure = 'Present'
            Name = 'Web-WMI'
        }
        
        WindowsFeature RSAT-ADDS
        {
            Ensure = 'Present'
            Name = 'RSAT-ADDS'
        }

        xWaitforDisk Disk2
        {
             DiskId = 2
             RetryIntervalSec = 60
             RetryCount = 60
        }

        xDisk MVolume
        {
             DiskId = 2
             DriveLetter = 'M'
             DependsOn = '[xWaitForDisk]Disk2'
        }
        
        xWaitforVolume WaitForMVolume
        {
             DriveLetter = 'M'
             RetryIntervalSec = 60
             RetryCount = 60
        }

        xWaitforDisk Disk3
        {
             DiskId = 3
             RetryIntervalSec = 60
             RetryCount = 60
        }

        xDisk SVolume
        {
             DiskId = 3
             DriveLetter = 'S'
             DependsOn = '[xWaitForDisk]Disk3'
        }

        xWaitforVolume WaitForSVolume
        {
             DriveLetter = 'S'
             RetryIntervalSec = 60
             RetryCount = 60
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }

        File CreateSoftwareFolder
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall'
            Ensure = "Present"
            DependsOn = '[xWaitForVolume]WaitForSVolume'
        }

        xRemoteFile DownloadExchange
        {
            DestinationPath = "S:\ExchangeInstall\Exchange2010.ISO"
            Uri             = "$ExchangeSASUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    '[File]CreateSoftwareFolder'
        }

        xRemoteFile DownloadFilterPack2010
        {
            DestinationPath = "S:\ExchangeInstall\FilterPack64bit.exe"
            Uri             = "https://download.microsoft.com/download/0/A/2/0A28BBFA-CBFA-4C03-A739-30CCA5E21659/FilterPack64bit.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = "[File]CreateSoftwareFolder"
        }

        xRemoteFile DownloadFilterPack2010SP2
        {
            DestinationPath = "S:\ExchangeInstall\filterpacksp2010-kb2687447-fullfile-x64-en-us.exe"
            Uri             = "https://download.microsoft.com/download/D/C/A/DCA32A51-6954-4814-8838-422BD3F508F8/filterpacksp2010-kb2687447-fullfile-x64-en-us.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PerSUserAgent]::InternetExplorer"
            DependsOn = '[File]CreateSoftwareFolder'
        }

        xRemoteFile DownloadUMCA
        {
            DestinationPath = "S:\ExchangeInstall\UcmaRuntimeSetup.exe"
            Uri             = "https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = "[File]CreateSoftwareFolder"
        }

        Package InstallFilterPack2010
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Path        = "S:\ExchangeInstall\FilterPack64bit.exe"
            Name        = "Download/Install Microsoft Office 2010 Filter Pack"
            ProductId   = "95140000-2000-0409-1000-0000000FF1CE"
            Arguments = "/passive"
            DependsOn   = '[xRemoteFile]DownloadFilterPack2010SP2'
        }

        Package InstallFilterPack2010SP2
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Path        = "S:\ExchangeInstall\filterpacksp2010-kb2687447-fullfile-x64-en-us.exe"
            Name        = "Download/Install Microsoft Office 2010 Filter Pack Service Pack 2"
            ProductId   = "95140000-2000-0409-1000-0000000FF1CE"
            Arguments = "/passive"
            DependsOn   = '[Package]InstallFilterPack2010'
        }

        Package InstallUCMA
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Path        = "S:\ExchangeInstall\UcmaRuntimeSetup.exe"
            Name        = "Download/Install Unified Communications Managed API 4.0 Runtime"
            ProductId   = "41D635FE-4F9D-47F7-8230-9B29D6D42D31"
            Arguments = "/passive"
            DependsOn   = "[Package]InstallFilterPack2010SP2"
        }

        xMountImage MountExchangeISO
        {
            ImagePath   = 'S:\ExchangeInstall\Exchange2010.iso'
            DriveLetter = 'I'
            DependsOn = '[Package]InstallUCMA'
        }

        xWaitForVolume WaitForISO
        {
            DriveLetter      = 'I'
            RetryIntervalSec = 5
            RetryCount       = 10
        }

        # Check if a reboot is needed before installing Exchange
        xPendingReboot BeforeExchangeInstall
        {
            Name       = 'BeforeExchangeInstall'
            DependsOn  = "[xWaitForVolume]WaitForISO"
        }
    }
}