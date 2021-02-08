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

                # Copy Linux Cert
                $FileCheck = Get-ChildItem -Path "C:\Certificates\FileCopiedSuccessfully.txt"
                IF ($FileCheck -eq $Null) {
                echo y | C:\Certificates\pscp.exe -P 22 -l $Username -pw $PlainPassword "C:\Certificates\sparktunnel.$using:domainName.pfx" $RemoteLinux  
                Set-Content -Path "C:\Certificates\FileCopiedSuccessfully.txt" -Value "File was copied successfully"
                } 
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]Certificates'
        }
    }
}