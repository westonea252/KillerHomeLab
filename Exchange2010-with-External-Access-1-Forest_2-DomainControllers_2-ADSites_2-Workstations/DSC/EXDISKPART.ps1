configuration EXDISKPART
{
   param
   (
        [String]$EXDiskPartUrl
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
            Uri             = $EXDiskPartUrl
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