configuration DOWNLOADEXCHANGE10
{
   param
   (
        [String]$ExchangeSP3ISOUrl

    )
    Import-DscResource -Module xStorage # Used for Mount ISO
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        File Machineconfig
        {
            Type = 'Directory'
            DestinationPath = 'C:\MachineConfig'
            Ensure = "Present"
        }

        xRemoteFile DownloadFile
        {
            DestinationPath = "C:\MachineConfig\Exchange2010SP3.ISO"
            Uri             = "$ExchangeSP3ISOUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]Machineconfig'
        }

        xMountImage MountExchangeISO
        {
            ImagePath   = "C:\MachineConfig\Exchange2010SP3.ISO"
            DriveLetter = 'I'
            DependsOn = '[xRemoteFile]DownloadFile'
        }

        xWaitForVolume WaitForISO
        {
            DriveLetter      = 'I'
            RetryIntervalSec = 5
            RetryCount       = 10
        }

        File PrepareADCCopy
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "I:\"
            DestinationPath = "C:\MachineConfig\Exchange2010SP3"
            DependsOn = '[xWaitForVolume]WaitForISO'
        }
    }
}