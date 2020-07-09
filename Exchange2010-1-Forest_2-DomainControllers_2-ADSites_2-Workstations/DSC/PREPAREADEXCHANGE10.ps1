configuration PREPAREADEXCHANGE10
{
   param
   (
        [String]$ExchangeOrgName,
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds

    )
    Import-DscResource -Module xStorage # Used for Mount ISO
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)    
    
    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature NET-Framework-Core
        {
            Ensure = 'Present'
            Name = 'NET-Framework-Core'
        }

        Script PrepareExchange2010
        {
            SetScript =
            {
                I:\Setup.com /PrepareSchema
                I:\Setup.com /PrepareAD /on:"$using:ExchangeOrgName"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }

    }
}