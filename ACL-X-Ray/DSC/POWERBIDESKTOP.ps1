Configuration POWERBIDESKTOP
{
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemote
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    Node localhost
    {
        File AclXRaySoftware
        {
            Type = 'Directory'
            DestinationPath = 'C:\AclXRaySoftware'
            Ensure = "Present"
        }

        xRemoteFile SSMS
        {
            DestinationPath = 'C:\AclXRaySoftware\PBIDesktopSetup_x64.exe'
            Uri             = "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    '[File]AclXRaySoftware'
        }

        Script InstallPowerBiDesktop
        {
            SetScript =
            {
                # Install PowerBi Desktop
                C:\AclXRaySoftware\PBIDesktopSetup_x64.exe /install /quiet /norestart
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]SSMS'
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }
     }
  }