Configuration CREATESUSERFOLDERS
{
   param
   (
        [String]$UserCount,
        [String]$UserDataUrl,
        [String]$NetBiosDomain,   
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node $AllNodes.NodeName

{
        File CreateDataFolder
        {
            Type = 'Directory'
            DestinationPath = "C:\Data"
            Ensure = "Present"
        }

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

        xRemoteFile DownloadUserData
        {
            DestinationPath = "C:\Data\UserData.zip"
            Uri             = $UserDataUrl
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]CreateDataFolder','[Registry]SchUseStrongCrypto','[Registry]SchUseStrongCrypto64'
        }

        $Number = 0
        foreach($Item in 1..$UserCount)
        {
            $Number += 1
            $UserName = "User$Number"

            File "CreateUserFolder$Number"
            {
                Type = 'Directory'
                DestinationPath = "C:\Users\$UserName"
                Ensure = "Present"
                DependsOn = '[File]CreateDataFolder'
            }

            Script UnzipUserData
            {
                SetScript =
                {
                    # UnCompress UserFolder
                    $UserFolderPath = Get-Item -Path "C:\Users\$using:UserName" -ErrorAction 0
                    IF ($UserFolderPath -ne $Null) {
                    Expand-Archive -Path "C:\Data\UserData.zip" -DestinationPath "C:\Users\$using:UserName"
                    }
                    ELSE {}
                }
                GetScript =  { @{} }
                TestScript = { $false}
                PsDscRunAsCredential = $DomainCreds
                DependsOn = "[ADUser]CreateUserFolder$Number"
            }
        }
    }
}