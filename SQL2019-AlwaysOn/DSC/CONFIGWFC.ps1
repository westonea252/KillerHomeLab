configuration CONFIGWFC
{
   param
   (
        [String]$SQLClusterName,     
        [String]$SQLNode1,     
        [String]$SQLNode2, 
        [String]$SQLDBName,
        [String]$SQLServiceAccount1,                     
        [String]$SQLServiceAccount2,                     
        [String]$NetBiosDomain,
        [String]$DomainName,
        [String]$StorageAccountName,
        [String]$StorageAccountKey,
        [String]$StorageEndpoint,        
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        File SQLBackup
        {
            Type = 'Directory'
            DestinationPath = 'C:\SQLBackup'
            Ensure = "Present"
        }

       Script CreateCluster
        {
            SetScript =
            {
                # Create Cluster
                $Cluster = Get-Cluster -Name "$using:SQLClusterName" -ErrorAction 0
                IF ($cluster -eq $null) {New-Cluster -Name "$using:SQLClusterName" -Node "$using:SQLNode1","$using:SQLNode2"}

		        # Create Cloud Storage Account
		        Set-ClusterQuorum -CloudWitness -AccountName "$using:StorageAccountName" -AccessKey "$using:StorageAccountKey" -EndPoint "$using:StorageEndPoint"

                # Enable SQL Always On
                Enable-SqlAlwaysOn -InputOBject "$using:SQLNode1"
                Enable-SqlAlwaysOn -InputOBject "$using:SQLNode2"
                Invoke-WmiMethod -Path "Win32_Service.Name='mssqlserver'" -Name StopService -Computername $SQLNode1
                Invoke-WmiMethod -Path "Win32_Service.Name='mssqlserver'" -Name StopService -Computername $SQLNode2
                Invoke-WmiMethod -Path "Win32_Service.Name='mssqlserver'" -Name StartService -Computername $SQLNode1
                Invoke-WmiMethod -Path "Win32_Service.Name='mssqlserver'" -Name StartService -Computername $SQLNode2

                # Create Database
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                Install-Module -Name dbatools -Force
                New-DbaDatabase -SqlInstance "$using:SQLNode1\MSSQLSERVER" -Name "$using:SQLDBName" -DataFilePath "F:\Data" -LogFilePath "G:\Log" -RecoveryModel 'Full' -Owner 'sa' -PrimaryFileSize '1024' -PrimaryFileGrowth '256' -LogSize '512' -LogGrowth '128' | Out-Null

                # Backup Database
                New-SmbShare -Name SQLBackup -Path C:\SQLBackup -FullAccess "$using:NetBiosDomain\$using:SQLServiceAccount1$","$using:NetBiosDomain\$using:SQLServiceAccount2$",Administrators
                Backup-SqlDatabase -Database "$using:SQLDBName" -BackupFile "\\$using:SQLNode1\SQLBackup\$using:SQLDBName.bak" -ServerInstance "$using:SQLNode1"
                Backup-SqlDatabase -Database "$using:SQLDBName" -BackupFile "\\$using:SQLNode1\SQLBackup\$using:SQLDBName.log" -ServerInstance "$using:SQLNode1" -BackupAction Log

                # Restore the database and log on the secondary (using NO RECOVERY)  
                Restore-SqlDatabase -Database "$using:SQLDBName" -BackupFile "\\$using:SQLNode1\SQLBackup\$using:SQLDBName.bak" -ServerInstance "$using:SQLNode2" -NoRecovery
                Restore-SqlDatabase -Database "$using:SQLDBName" -BackupFile "\\$using:SQLNode1\SQLBackup\$using:SQLDBName.log" -ServerInstance "$using:SQLNode2" -RestoreAction Log -NoRecovery
  
                # Create an in-memory representation of the primary replica. 
                $Port = ":5022" 
                $primaryReplica = New-SqlAvailabilityReplica -Name "$using:SQLNode1" -EndpointURL "TCP://$using:SQLNode1.$using:DomainName$Port" -AvailabilityMode "SynchronousCommit" -FailoverMode "Automatic" -Version 12 -AsTemplate
  
                # Create an in-memory representation of the secondary replica.  
                $secondaryReplica = New-SqlAvailabilityReplica -Name "$using:SQLNode2" -EndpointURL "TCP://$using:SQLNode2.$using:DomainName$Port" -AvailabilityMode "SynchronousCommit" -FailoverMode "Automatic" -Version 12 -AsTemplate
  
                # Create the availability group  
                New-SqlAvailabilityGroup -Name "SQL-AG" -Path "SQLSERVER:\SQL\$using:SQLNode1\DEFAULT" -AvailabilityReplica @($primaryReplica,$secondaryReplica) -Database "$using:SQLDBName"
  
                # Join the secondary replica to the availability group.  
                Join-SqlAvailabilityGroup -Path "SQLSERVER:\SQL\$using:SQLNode2\DEFAULT" -Name "SQL-AG"  
  
                # Join the secondary database to the availability group.  
                Add-SqlAvailabilityDatabase -Path "SQLSERVER:\SQL\$using:SQLNode2\DEFAULT\AvailabilityGroups\SQL-AG" -Database "$using:SQLDBName"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
            DependsOn = '[File]SQLBackup'
        }
    }
}