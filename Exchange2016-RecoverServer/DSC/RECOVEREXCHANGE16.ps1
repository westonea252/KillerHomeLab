configuration RECOVEREXCHANGE16
{
   param
   (
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

        File ExchangeInstall
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall'
            Ensure = "Present"
        }

        Script InstallExchange2016
        {
            SetScript =
            {
                Set-Content -Path S:\ExchangeInstall\RecoverExchange.cmd -Value "J:\Setup.exe /Mode:RecoverServer /IAcceptExchangeServerLicenseTerms"
                S:\ExchangeInstall\RecoverExchange.cmd
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }

    }
}