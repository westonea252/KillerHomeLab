configuration EXDISKPART
{
   param
   (
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    Node localhost
    {
        File DiskConfig
        {
            Type = 'Directory'
            DestinationPath = 'C:\DiskConfig'
            Ensure = "Present"
        }

        xRemoteFile DiskPart
        {
            DestinationPath = "C:\DiskConfig\ExchangeDiskPart.txt"
            Uri             = "https://raw.githubusercontent.com/elliottfieldsjr/KillerHomeLab/master/Exchange2010-1-Forest_2-DomainControllers_2-ADSites_2-Workstations/Scripts/ExchangeDiskpart.txt"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    "[File]DiskConfig"
        }

        Script ConfigureDisks
        {
            SetScript =
            {
                # Partition Volumes
                C:\Windows\System32\diskpart.exe /s C:\DiskConfig\ExchangeDiskPart.txt
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]DiskPart'
        }
    }
}