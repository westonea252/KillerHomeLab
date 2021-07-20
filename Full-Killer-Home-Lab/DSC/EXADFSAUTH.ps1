configuration EXADFSAUTH
{
   param
   (
        [String]$ComputerName,
        [String]$ADFSServerName,
        [String]$InternaldomainName,
        [String]$ExternaldomainName,                                
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

        File ADFSCertificates
        {
            Type = 'Directory'
            DestinationPath = 'C:\ADFSCertificates'
            Ensure = "Present"
        }

        File CopyADFSCerts
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "\\$ADFSServerName\c$\Certificates"
            DestinationPath = "C:\ADFSCertificates\"
            Credential = $Admincreds
            DependsOn = '[File]ADFSCertificates'
        }

        Script ConfigureExchangeADFSAuth
        {
            SetScript =
            {
                (Get-ADDomainController -Filter *).Name | Foreach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /AdeP }
                
                # Connect to Exchange
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$using:computerName.$using:InternalDomainName/PowerShell/"
                Import-PSSession $Session

                # Load ADFS Thumbprint
                $ADFSThumbprint = Get-Content -Path "C:\ADFSCertificates\ADFSThumbprint.txt"

                # Set Organization Config
                $uris = @("https://owa2019.$using:ExternalDomainName/OWA","https://owa2019.$using:ExternalDomainName/ECP")
                Set-OrganizationConfig -AdfsIssuer "https://adfs.$using:ExternalDomainName/adfs/ls/" -AdfsAudienceUris $uris -AdfsSignCertificateThumbprint "$ADFSThumbprint"

                # ADFS on FORMS off
                Get-EcpVirtualDirectory | Set-EcpVirtualDirectory -AdfsAuthentication $true -BasicAuthentication $false -DigestAuthentication $false -FormsAuthentication $false -WindowsAuthentication $false
                Get-OwaVirtualDirectory | Set-OwaVirtualDirectory -AdfsAuthentication $true -BasicAuthentication $false -DigestAuthentication $false -FormsAuthentication $false -WindowsAuthentication $false

            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
            DependsOn = '[File]CopyADFSCerts'
        }
    }
}