configuration CONFIGDAG
{
   param
   (
        [String]$ComputerName,  
        [String]$InternaldomainName,                    
        [String]$NetBiosDomain,
        [String]$BaseDN,
        [String]$Site1DC,
        [String]$Site2DC,
        [String]$ConfigDC,
        [String]$Site1FSW,
        [String]$DAGName,
        [String]$PassiveDAGNode,
        [String]$DB1Name,
        [String]$DB2Name,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        Script ConfigureDAGandDatabaseCopies
        {
            SetScript =
            {
                repadmin /replicate "$using:Site1DC" "$using:Site2DC" "$using:BaseDN"
                repadmin /replicate "$using:Site2DC" "$using:Site1DC" "$using:BaseDN"

                # Connect to Exchange
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$using:computerName.$using:InternalDomainName/PowerShell/"
                Import-PSSession $Session

                # Create DAG
                $DAGCheck = Get-DatabaseAvailabilityGroup -Identity "$using:DAGName" -DomainController "$using:ConfigDC" -ErrorAction 0
                IF ($DAGCheck -eq $null) {
                New-DatabaseAvailabilityGroup -Name "$using:DAGName" -WitnessServer "$using:Site1FSW" -WitnessDirectory C:\FSWs -DomainController "$using:ConfigDC"
                Add-DatabaseAvailabilityGroupServer -Identity "$using:DAGName" -MailboxServer "$using:computerName" -DomainController "$using:ConfigDC"
                Add-DatabaseAvailabilityGroupServer -Identity "$using:DAGName" -MailboxServer "$using:PassiveDAGNode" -DomainController "$using:ConfigDC"
                }

                repadmin /replicate "$using:Site1DC" "$using:Site2DC" "$using:BaseDN"
                repadmin /replicate "$using:Site2DC" "$using:Site1DC" "$using:BaseDN"

                # Create Database Copies
                $DB1CopyCheck = Get-MailboxDatabase -Server "$using:PassiveDAGNode" | Where-Object {$_.Name -like "$using:DB1Name"}
                IF ($DB1CopyCheck -eq $null) {
                Add-MailboxDatabaseCopy -Identity "$using:DB1Name" -MailboxServer "$using:PassiveDAGNode"
                }

                $DB2CopyCheck = Get-MailboxDatabase -Server "$using:ComputerName" | Where-Object {$_.Name -like "$using:DB2Name"}
                IF ($DB2CopyCheck -eq $null) {
                Add-MailboxDatabaseCopy -Identity "$using:DB2Name" -MailboxServer "$using:ComputerName"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }
    }
}