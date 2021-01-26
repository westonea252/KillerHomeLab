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
        File CopyCABackup
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "\\$BackupCAIP\c$\CABackup"
            DestinationPath = "C:\CARestore\"
            Credential = $Admincreds
        }
     }
  }