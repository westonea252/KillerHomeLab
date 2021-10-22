﻿configuration CREATEWFC
{
   param
   (
        [String]$SQLClusterName,
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xFailoverCluster # Used for Reboots

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        xCluster CreateCluster
        {
            Name = $SQLClusterName
            DomainAdministratorCredential = $DomainCreds
        }
    }
}