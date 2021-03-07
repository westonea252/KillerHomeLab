configuration KB5000871
{
   param
   (
        [String]$CUPatchUrl,     
        [String]$CUPatchScriptUrl
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module xPendingReboot # Used for Reboots

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

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        xRemoteFile CUPatch
        {
            DestinationPath = "S:\ExchangeInstall\Exchange2016-KB5000871-x64-en.msp"
            Uri             = $CUPatchUrl
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
        }

        xRemoteFile CUHealthCheck
        {
            DestinationPath = "S:\ExchangeInstall\HealthChecker.ps1"
            Uri             = $CUPatchScriptUrl
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

        # Check if a reboot is needed before installing Exchange
        xPendingReboot BeforeExchangeInstall
        {
            Name       = 'BeforeExchangeInstall'
            DependsOn  = "[Script]CUHealthCheck"
        }
    }
}