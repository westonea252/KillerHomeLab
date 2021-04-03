Configuration CREATEUSERFOLDERS
{
   param
   (
        [String]$UserCount,
        [String]$NamingConvention,     
        [String]$UserDataUrl,
        [String]$NetBiosDomain,   
        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )

    Import-DscResource -Module xStorage
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    Node $AllNodes.NodeName

{
        xWaitforDisk Disk2
        {
            DiskID = 2
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        xDisk ADDataDisk {
            DiskID = 2
            DriveLetter = "H"
            DependsOn = "[xWaitForDisk]Disk2"
        }

        File CreateDataFolder
        {
            Type = 'Directory'
            DestinationPath = "H:\Data"
            Ensure = "Present"
            DependsOn = '[xDisk]ADDataDisk'
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
            DestinationPath = "H:\Data\UserData.zip"
            Uri             = $UserDataUrl
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]CreateDataFolder','[Registry]SchUseStrongCrypto','[Registry]SchUseStrongCrypto64'
        }

        $Number = 0
        foreach($Item in 1..$UserCount)
        {
            $Number += 1

            File "CreateUserFolder$Number"
            {
                Type = 'Directory'
                DestinationPath = "H:\Users\$UserName"
                Ensure = "Present"
                DependsOn = '[File]CreateDataFolder'
            }

            Script "UnzipUserData$Number"
            {
                SetScript =
                {
                    # UnCompress UserFolder
                    $UserFolderPath = Get-Item -Path "H:\Users\$using:UserName" -ErrorAction 0
                    IF ($UserFolderPath -ne $Null) {
                    Expand-Archive -Path "H:\Data\UserData.zip" -DestinationPath "H:\Users\$using:UserName"
                    }
                    ELSE {}
                }
                GetScript =  { @{} }
                TestScript = { $false}
                DependsOn = "[File]CreateUserFolder$Number"
            }
        }
    }
}