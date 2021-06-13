configuration CONFIGDNS
{
   param
   (
        [String]$computerName,
        [String]$NetBiosDomain,
        [String]$InternaldomainName,
        [String]$ExternaldomainName,
        [String]$ReverseLookup1,
        [String]$dc1lastoctet,
        [String]$icaIP,
        [String]$ocspIP,
        [String]$ex1IP,
        [Int]$RetryIntervalSec=420,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xDnsServer
    Import-DscResource -ModuleName ActiveDirectoryDsc

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        WaitForADDomain DscForestWait
        {
            DomainName = $InternaldomainName
            Credential= $DomainCreds
            WaitTimeout = $RetryIntervalSec
        }

        xDnsServerADZone ExternalDomain
        {
            Name             = "$ExternaldomainName"
            DynamicUpdate = 'Secure'
            Ensure           = 'Present'
            ReplicationScope = 'Domain'
            DependsOn = '[WaitForADDomain]DscForestWait'
        }

        xDnsServerADZone ReverseADZone1
        {
            Name             = "$ReverseLookup1.in-addr.arpa"
            DynamicUpdate = 'Secure'
            Ensure           = 'Present'
            ReplicationScope = 'Domain'
            DependsOn = '[WaitForADDomain]DscForestWait'
        }

        xDnsRecord DC1PtrRecord
        {
            Name      = "$dc1lastoctet"
            Zone      = "$ReverseLookup1.in-addr.arpa"
            Target    = "$computerName.$InternaldomainName"
            Type      = 'Ptr'
            Ensure    = 'Present'
            DependsOn = "[xDnsServerADZone]ReverseADZone1"
        }

        xDnsRecord crlrecord
        {
            Name      = "crl"
            Zone      = "$ExternaldomainName"
            Target    = "$icaIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
        }

        xDnsRecord ocsprecord
        {
            Name      = "ocsp"
            Zone      = "$ExternaldomainName"
            Target    = "$ocspIP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
        }

        xDnsRecord owa2019record1
        {
            Name      = "owa2019"
            Zone      = "$ExternaldomainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
        }

        xDnsRecord autodiscover2019record1
        {
            Name      = "autodiscover2019"
            Zone      = "$ExternaldomainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
        }

        xDnsRecord outlook2019record1
        {
            Name      = "outlook2019"
            Zone      = "$ExternaldomainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
         }

        xDnsRecord eas2019record1
        {
            Name      = "eas2019"
            Zone      = "$ExternaldomainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
         }

        xDnsRecord smtprecord1
        {
            Name      = "smtp"
            Zone      = "$ExternaldomainName"
            Target    = "$ex1IP"
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]ExternalDomain'
         }
    }
}