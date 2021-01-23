Configuration CABACKUPTRANSFER1
{
   param
   (
        [String]$NetBiosDomain,   
        [String]$RootCAIP,              
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($AdminCreds.UserName)", $AdminCreds.Password)

    Node localhost
    {
        File CABackup
        {
            Type = 'Directory'
            DestinationPath = 'C:\CABackup'
            Ensure = "Present"
        }

        File CopyCABackup
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "\\$RootCAIP\c$\CABackup"
            DestinationPath = "C:\CABackup\"
            Credential = $DomainCreds
            DependsOn = '[File]CABackup'
        }
     }
  }