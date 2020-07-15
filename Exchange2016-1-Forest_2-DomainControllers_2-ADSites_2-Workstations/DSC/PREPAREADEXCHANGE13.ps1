configuration PREPAREADEXCHANGE13
{
   param
   (
        [String]$ExchangeOrgName,
        [String]$NetBiosDomain,
        [String]$DC1Name,
        [System.Management.Automation.PSCredential]$Admincreds
    )
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script PrepareExchange2013AD
        {
            SetScript =
            {
                # Create Exchange AD Deployment
                K:\Setup.exe /PrepareSchema /DomainController:"$using:dc1Name" /IAcceptExchangeServerLicenseTerms
                K:\Setup.exe /PrepareAD /on:"$using:ExchangeOrgName" /DomainController:"$using:dc1Name" /IAcceptExchangeServerLicenseTerms
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }
    }
}