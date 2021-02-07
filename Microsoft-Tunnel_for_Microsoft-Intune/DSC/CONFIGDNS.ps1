configuration CONFIGDNS
{
   param
   (
        [String]$computerName,
        [String]$NetBiosDomain,
        [String]$dc1lastoctet,
        [String]$InternaldomainName,
        [String]$ExternaldomainName,
        [String]$ReverseLookup1,
        [String]$EnterpriseCAIP,
        [String]$OCSPIP,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xDnsServer

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($AdminCreds.UserName)", $AdminCreds.Password)

    Node localhost
    {
        xDnsServerADZone ExternalDomain
        {
            Name             = "$ExternaldomainName"
            DynamicUpdate = 'Secure'
            Ensure           = 'Present'
            ReplicationScope = 'Domain'
        }

        xDnsServerADZone ReverseADZone1
        {
            Name             = "$ReverseLookup1.in-addr.arpa"
            DynamicUpdate = 'Secure'
            Ensure           = 'Present'
            ReplicationScope = 'Domain'
        }

        xDnsRecord DC1PtrRecord
        {
            Name      = "$dc1lastoctet"
            Zone      = "$ReverseLookup1.in-addr.arpa"
            Target    = "$computerName.$DomainName"
            Type      = 'Ptr'
            Ensure    = 'Present'
            DependsOn = "[xDnsServerADZone]ReverseADZone1"
        }

        xDnsRecord crlrecord
        {
            Name      = "crl"
            Zone      = "$ExternaldomainName"
            Target    = "$EnterpriseCAIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
        }

        xDnsRecord ocsprecord
        {
            Name      = "ocsp"
            Zone      = "$ExternaldomainName"
            Target    = "$OCSPIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
        }
    }
}