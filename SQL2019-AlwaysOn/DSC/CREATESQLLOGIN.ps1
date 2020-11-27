configuration CREATESQLLOGIN
{
   param
   (
        [String]$computerName,
        [String]$Account,
        [String]$NetBiosDomain,
        [String]$DomainName,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Import-DscResource -Module SqlServerDsc

    Node localhost
    {
        SqlLogin CreateInstallSQLLogin
        {
            Ensure               = 'Present'
            Name                 = "$NetBiosDomain\$Account"
            LoginType            = 'WindowsUser'
            ServerName           = "$ComputerName.$DomainName"
            InstanceName         = 'SQL Server (MSSQLSERVER)'
            PsDscRunAsCredential = $Admincreds
        }

    }
}