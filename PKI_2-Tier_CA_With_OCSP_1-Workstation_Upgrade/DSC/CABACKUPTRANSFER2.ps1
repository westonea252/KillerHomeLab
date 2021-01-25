Configuration CABACKUPTRANSFER2
{
   param
   (
        [String]$NetBiosDomain,   
        [String]$BackupCAIP,              
        [System.Management.Automation.PSCredential]$Admincreds
    )

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
            SourcePath = "\\$BackupIP\c$\CABackup"
            DestinationPath = "C:\CABackup\"
            Credential = $AdminCreds
            DependsOn = '[File]CABackup'
        }
     }
  }