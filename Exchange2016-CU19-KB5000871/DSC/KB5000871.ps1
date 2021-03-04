configuration KB5000871
{
   param
   (
        [String]$CUPatchUrl,     
        [String]$ScriptUrl
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
                # Install .Net 4.8
                S:\ExchangeInstall\ndp48-x86-x64-allos-enu.exe /q
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]CUPatch'
        }

        Script CUHealthCheck
        {
            SetScript =
            {
                # Install .Net 4.8
                S:\ExchangeInstall\ndp48-x86-x64-allos-enu.exe /q
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]CUPatchInstall'
        }

        # Check if a reboot is needed before installing Exchange
        xPendingReboot BeforeExchangeInstall
        {
            Name       = 'BeforeExchangeInstall'
            DependsOn  = "[Package]Installvsredist2013"
        }
    }
}