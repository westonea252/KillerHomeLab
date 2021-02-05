configuration CONFIGEXCHANGE19
{
   param
   (
        [String]$ComputerName,
        [String]$RootDomainFQDN,                
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        File Certificates
        {
            Type = 'Directory'
            DestinationPath = 'C:\Certificates'
            Ensure = "Present"
        }

        Script ConfigureCertificate
        {
            SetScript =
            {
                # Create Credentials
                $Load = "$using:DomainCreds"
                $Password = $DomainCreds.Password

                # Get Certificate Spark Tunnel Certificate
                $CertCheck = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=sparktunnel.$using:RootDomainFQDN"}
                IF ($CertCheck -eq $Null) {Get-Certificate -Template WebServer1 -SubjectName "CN=sparktunnel.$using:RootDomainFQDN" -DNSName "sparktunnel.$using:RootDomainFQDN" -CertStoreLocation "cert:\LocalMachine\My"}

                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=sparktunnel.$using:RootDomainFQDN"}).Thumbprint
                (Get-ChildItem -Path Cert:\LocalMachine\My\$thumbprint).FriendlyName = "Spark Tunnel Cert"

                # Export Service Communication Certificate
                $CertFile = Get-ChildItem -Path "C:\Certificates\sparktunnel.$using:RootDomainFQDN.pfx" -ErrorAction 0
                IF ($CertFile -eq $Null) {Get-ChildItem -Path cert:\LocalMachine\my\$thumbprint | Export-PfxCertificate -FilePath "C:\Certificates\sparktunnel.$using:RootDomainFQDN.pfx" -Password $Password}

                # Share Certificate
                $CertShare = Get-SmbShare -Name Certificates -ErrorAction 0
                IF ($CertShare -eq $Null) {New-SmbShare -Name Certificates -Path C:\Certificates -FullAccess Administrators}
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]Certificates'
        }
    }
}