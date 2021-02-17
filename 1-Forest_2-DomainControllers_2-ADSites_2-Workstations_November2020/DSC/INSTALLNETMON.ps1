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
            Uri             = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=4865&6B49FDFB-8E5B-4B07-BC31-15695C5A2143=1"
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