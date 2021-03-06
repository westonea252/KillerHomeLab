configuration PREPARERECOVERY16
{
   param
   (
        [String]$ComputerName,
        [String]$NetBiosDomain,
        [String]$DAGName,
        [String]$DBName,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        Script PrepareRecovery
        {
            SetScript =
            {
                Remove-MailboxDatabaseCopy "$using:DBName\$using:ComputerName"
                Remove-DatabaseAvailabilityGroupServer -Identity "$using:DAGName" -MailboxServer "$using:ComputerName"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }

    }
}