configuration CONFIGDNS
{
   param
   (
        [String]$computerName,
        [String]$dc1lastoctet,
        [String]$dc2lastoctet,
        [String]$ex1IP,
        [String]$ex2IP,
        [String]$icaIP,
        [String]$ocspIP,
        [String]$domainName,
        [String]$ReverseLookup1,
        [String]$ReverseLookup2
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

        xDnsServerADZone ReverseADZone2
        {
            Name             = "$ReverseLookup2.in-addr.arpa"
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

        xDnsRecord DC2PtrRecord
        {
            Name      = "$dc2lastoctet"
            Zone      = "$ReverseLookup2.in-addr.arpa"
            Target    = "$computerName.$DomainName"
            Type      = 'Ptr'
            Ensure    = 'Present'
            DependsOn = "[xDnsServerADZone]ReverseADZone2"
        }

        xDnsRecord crlrecord
        {
            Name      = "crl"
            Zone      = "$domainName"
            Target    = "$icaIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }

        xDnsRecord ocsprecord
        {
            Name      = "ocsp"
            Zone      = "$domainName"
            Target    = "$ocspIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }

        xDnsRecord owa2013record1
        {
            Name      = "owa2013"
            Zone      = "$domainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }

        xDnsRecord owa2013record2
        {
            Name      = "owa2013"
            Zone      = "$domainName"
            Target    = "$ex2IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }

        xDnsRecord autodiscover2013record1
        {
            Name      = "autodiscover2013"
            Zone      = "$domainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }

        xDnsRecord autodiscover2013record2
        {
            Name      = "autodiscover2013"
            Zone      = "$domainName"
            Target    = "$ex2IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
        }

        xDnsRecord outlook2013record1
        {
            Name      = "outlook2013"
            Zone      = "$domainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
         }

        xDnsRecord outlook2013record2
        {
            Name      = "outlook2013"
            Zone      = "$domainName"
            Target    = "$ex2IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
         }

        xDnsRecord eas2013record1
        {
            Name      = "eas2013"
            Zone      = "$domainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
         }

        xDnsRecord eas2013record2
        {
            Name      = "eas2013"
            Zone      = "$domainName"
            Target    = "$ex2IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
         }

        xDnsRecord smtprecord1
        {
            Name      = "smtp"
            Zone      = "$domainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
         }

        xDnsRecord smtprecord2
        {
            Name      = "smtp"
            Zone      = "$domainName"
            Target    = "$ex2IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
         }

    }
}