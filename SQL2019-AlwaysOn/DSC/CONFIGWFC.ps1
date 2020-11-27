configuration CONFIGWFC
{
   param
   (
        [String]$SQLClusterName,     
        [String]$SQLNode1,     
        [String]$SQLNode2,     
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )

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
                $Cluster = Get-Cluster -Name "$using:SQLClusterName"  -ErrorAction 0
                IF ($cluster -eq $null) {New-Cluster -Name "$using:SQLClusterName" -Node "$using:SQLNode1","$using:SQLNode2"}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}