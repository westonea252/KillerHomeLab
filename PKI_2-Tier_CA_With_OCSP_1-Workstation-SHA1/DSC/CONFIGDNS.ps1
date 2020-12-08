configuration CONFIGDNS
{
   param
   (
        [String]$computerName,
        [String]$dc1lastoctet,
        [String]$domainName,
        [String]$ReverseLookup1,
        [String]$ISSUINGCAIP,
        [String]$OCSPIP
    )

    Import-DscResource -Module xDnsServer

    Node localhost
    {
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
            Zone      = "$domainName"
            Target    = "$ISSUINGCAIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }

        xDnsRecord ocsprecord
        {
            Name      = "ocsp"
            Zone      = "$domainName"
            Target    = "$OCSPIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }
    }
}