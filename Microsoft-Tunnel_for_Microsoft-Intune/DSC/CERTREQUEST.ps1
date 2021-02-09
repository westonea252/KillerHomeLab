configuration CERTREQUEST
{
   param
   (
        [String]$ComputerName,
        [String]$TimeZone,  
        [String]$gwIP, 
        [String]$domainName,                
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xPSDesiredStateConfiguration

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

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

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        File Certificates
        {
            Type = 'Directory'
            DestinationPath = 'C:\Certificates'
            Ensure = "Present"
        }

        xRemoteFile cscp
        {
            DestinationPath = "C:\Certificates\pscp.exe"
            Uri             = "https://the.earth.li/~sgtatham/putty/latest/w64/pscp.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = "[File]Certificates"
        }

        xRemoteFile Downloadvsredist
        {
            DestinationPath = "C:\Certificates\vc_redist.x64.exe"
            Uri             = "https://aka.ms/vs/16/release/vc_redist.x64.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]Certificates'
        }

        xRemoteFile DownloadOpenSSL
        {
            DestinationPath = "C:\Certificates\OpenSSL.exe"
            Uri             = "https://slproweb.com/download/Win64OpenSSL_Light-1_1_1i.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]Certificates'
        }

        Package Installvsredist
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Path        = "C:\Certificates\vc_redist.x64.exe"
            Name        = "Microsoft Visual C++ 2019 X64 Minimum Runtime - 14.28.29325"
            ProductId   = "7D0362D5-C699-4403-BC09-0C1DAD1D93AB"
            Arguments = "/passive"
            DependsOn   = "[xRemoteFile]Downloadvsredist"
        }

        Script InstallOpenSSL
        {
            SetScript =
            {
                C:\Certificates\OpenSSL.exe /VERYSILENT
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]DownloadOpenSSL'
        }

        Script ConfigureCertificate
        {
            SetScript =
            {
                $Load = "$using:DomainCreds"
                $Domain = $DomainCreds.GetNetworkCredential().Domain
                $Username = $DomainCreds.GetNetworkCredential().Username
                $PlainPassword = $DomainCreds.GetNetworkCredential().Password
                $SecurePassword = $DomainCreds.Password
                $RemoteLinux = "$using:gwIP"+":/home/"+$Username

                # Update Trusted CA's
                gpupdate /force

                # Get Certificate Spark Tunnel Certificate
                $CertCheck = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=sparktunnel.$using:domainName"}
                IF ($CertCheck -eq $Null) {Get-Certificate -Template WebServer1 -SubjectName "CN=sparktunnel.$using:domainName" -DNSName "sparktunnel.$using:domainName" -CertStoreLocation "cert:\LocalMachine\My"}

                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=sparktunnel.$using:domainName"}).Thumbprint
                (Get-ChildItem -Path Cert:\LocalMachine\My\$thumbprint).FriendlyName = "Spark Tunnel Cert"

                # Export Service Communication Certificate
                $CertFile = Get-ChildItem -Path "C:\Certificates\sparktunnel.$using:domainName.pfx" -ErrorAction 0
                IF ($CertFile -eq $Null) {Get-ChildItem -Path cert:\LocalMachine\my\$thumbprint | Export-PfxCertificate -FilePath "C:\Certificates\sparktunnel.$using:domainName.pfx" -Password $SecurePassword}

                # Share Certificate
                $CertShare = Get-SmbShare -Name Certificates -ErrorAction 0
                IF ($CertShare -eq $Null) {New-SmbShare -Name Certificates -Path C:\Certificates -FullAccess Administrators}

                # Convert PFX to PEM
                & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" pkcs12 -in "C:\Certificates\sparktunnel.$using:domainName.pfx" -out "C:\Certificates\sparktunnel.$using:domainName.pem" -passin pass:$PlainPassword -passout pass:$PlainPassword

                # Copy Linux Cert
                $FileCheck = Get-ChildItem -Path "C:\Certificates\FileCopiedSuccessfully.txt" -ErrorAction 0
                IF ($FileCheck -eq $Null) {

                echo y | C:\Certificates\pscp.exe -batch -P 22 -l $Username -pw $PlainPassword -batch "C:\Certificates\sparktunnel.$using:domainName.pem" $RemoteLinux  
                Set-Content -Path "C:\Certificates\FileCopiedSuccessfully.txt" -Value "File was copied successfully"
                } 
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]InstallOpenSSL'
        }
    }
}