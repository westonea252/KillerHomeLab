configuration INSTALLNETMON
{
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

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

        File CreateToolsFolder
        {
            Type = 'Directory'
            DestinationPath = 'C:\Tools'
            Ensure = "Present"
        }

        xRemoteFile DownloadNetmon
        {
            DestinationPath = "C:\Tools\NM34_x64.exe"
            Uri             = "https://download.microsoft.com/download/7/1/0/7105C7FF-768E-4472-AFD5-F29108D1E383/NM34_x64.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[Registry]SchUseStrongCrypto'
        }

        Script InstallNetmon
        {
            SetScript =
            {
                # Install Netmon
                C:\Tools\NM34_x64.exe /q
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]DownloadNetmon'
        }
    }
}