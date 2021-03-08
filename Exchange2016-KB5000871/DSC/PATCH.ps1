configuration PATCH
{
   param
   (
        [String]$CUPatchUrl,     
        [String]$CUPatchScriptUrl
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        xRemoteFile CUPatch
        {
            DestinationPath = "S:\ExchangeInstall\Exchange2016-KB5000871-x64-en.msp"
            Uri             = "$CUPatchUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
        }

        xRemoteFile CUHealthCheck
        {
            DestinationPath = "S:\ExchangeInstall\HealthChecker.ps1"
            Uri             = "$CUPatchScriptUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]CUPatch'
        }        

        Script CUPatchInstall
        {
            SetScript =
            {
                S:\ExchangeInstall\Exchange2016-KB5000871-x64-en.msp /quiet
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]CUPatch'
        }

        Script CUHealthCheck
        {
            SetScript =
            {
                S:\ExchangeInstall\HealthChecker.ps1
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]CUPatchInstall','[xRemoteFile]CUHealthCheck'
        }
    }
}