Configuration SSMS
{
 
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemote
 
    Node localhost
    {
        WindowsFeature 'NetFramework45'
        {
            Name   = 'NET-Framework-45-Core'
            Ensure = 'Present'
        }


        File SQLSoftware
        {
            Type = 'Directory'
            DestinationPath = 'C:\SQLSoftware'
            Ensure = "Present"
        }

        xRemoteFile SSMS
        {
            DestinationPath = 'C:\SQLSoftware\SSMS-Setup-ENU.exe'
            Uri             = "https://aka.ms/SSMSFullSetup"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    "[File]SQLSoftware"
        }


        Script InstallSQLManagementStudio
        {
            SetScript =
            {
                # Install SQL Management Studio
                C:\SQLSoftware\SSMS-Setup-ENU.exe /install /quiet /norestart

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