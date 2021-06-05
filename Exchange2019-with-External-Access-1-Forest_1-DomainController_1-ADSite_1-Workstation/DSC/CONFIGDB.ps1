configuration CONFIGDB
{
   param
   (
        [String]$ComputerName,  
        [String]$InternaldomainName,                    
        [String]$NetBiosDomain,
        [String]$DBName,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        Script ConfigureDAGandDatabaseCopies
        {
            SetScript =
            {
                # Connect to Exchange
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$using:computerName.$using:InternalDomainName/PowerShell/"
                Import-PSSession $Session

                # Create Database Copies
                $DBCopyCheck = Get-MailboxDatabase -Server "$using:ComputerName" | Where-Object {$_.Name -like "$using:DBName"}
                IF ($DBCopyCheck -eq $null) {
                Add-MailboxDatabaseCopy -Identity "$using:DBName" -MailboxServer "$using:ComputerName"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }
    }
}