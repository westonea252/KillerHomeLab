configuration CREATESITES
{
   param
   (
        [String]$computerName,
        [String]$NamingConvention,
        [String]$BaseDN,
        [String]$Site1Prefix
    )

    Import-DscResource -Module xActiveDirectory

    Node localhost
    {

        xADReplicationSite Site1
        {
            Ensure = 'Present'
            Name   = "$NamingConvention-Site1"
        }

        xADReplicationSubnet Site1Subnet1
        {
            Name     = $Site1Prefix
            Site     = "$NamingConvention-Site1"
            DependsOn = "[xADReplicationSite]Site1"
        }

        Script UpdateDNSSettings
        {
            SetScript =
            {

                # Move First Domain Controller
                $Site1DN = "CN=$using:NamingConvention-Site1,CN=Sites,CN=Configuration,$using:BaseDN"
                Move-ADDirectoryServer -Identity $using:computerName -Site $Site1DN

            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}