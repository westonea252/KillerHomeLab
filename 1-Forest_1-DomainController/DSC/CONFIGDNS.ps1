configuration CONFIGDNS
{
   param
   (
        [String]$computerName,
        [String]$domainName,
        [String]$ReverseLookup1
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
            Name      = "111"
            Zone      = "$ReverseLookup1.in-addr.arpa"
            Target    = "$computerName.$DomainName"
            Type      = 'Ptr'
            Ensure    = 'Present'
            DependsOn = "[xDnsServerADZone]ReverseADZone1"
        }
    }
}