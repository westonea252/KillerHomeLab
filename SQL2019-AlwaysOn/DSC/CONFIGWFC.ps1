configuration CONFIGWFC
{
   param
   (
        [String]$SQLClusterName,     
        [String]$SQLNode1,     
        [String]$SQLNode2,     
        [String]$NetBiosDomain,
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

       Script CreateCluster
        {
            SetScript =
            {
                # Create Cluster
                $Cluster = Get-Cluster -Name "$using:SQLClusterName" -ErrorAction 0
                IF ($cluster -eq $null) {New-Cluster -Name "$using:SQLClusterName" -Node "$using:SQLNode1","$using:SQLNode2"}

		        # Create Cloud Storage Account
		        Set-ClusterQuorum -CloudWitness -AccountName "$using:StorageAccountName" -AccessKey "$using:StorageAccountKey" -EndPoint "$using:StorageEndPoint"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }
    }
}