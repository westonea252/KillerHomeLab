Configuration DOWNLOADAADDC
{
   param
   (
        [String]$AzureADConnectDownloadUrl,
        [System.Management.Automation.PSCredential]$Admincreds
    )
 
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemote

    Node localhost
    {        
        File ADConnectInstall
        {
            Type = 'Directory'
            DestinationPath = 'C:\ADConnectInstall'
            Ensure = "Present"
        }

        xRemoteFile DownloadAzureADConnect
        {
            DestinationPath = 'C:\ADConnectInstall\AzureADConnect.msi'
            Uri             = "$AzureADConnectDownloadUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    "[File]ADConnectInstall"
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }
     }
  }