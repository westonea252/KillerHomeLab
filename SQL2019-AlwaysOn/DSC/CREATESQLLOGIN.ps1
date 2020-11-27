configuration CREATESQLLOGIN
{
   param
   (
        [String]$computerName,
        [String]$InstallAccount,
        [String]$SvcAccount,        
        [String]$NetBiosDomain,
        [String]$DomainName,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)
    [System.Management.Automation.PSCredential ]$Sqlsvc = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$SvcAccount", $Admincreds.Password)

    Import-DscResource -Module SqlServerDsc # Used for SQL Configurations
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    Node localhost
    {
        SqlLogin CreateInstallSQLLogin
        {
            Ensure               = 'Present'
            Name                 = "$NetBiosDomain\$InstallAccount"
            LoginType            = 'WindowsUser'
            ServerName           = "$ComputerName.$DomainName"
            InstanceName         = 'MSSQLSERVER'
            PsDscRunAsCredential = $Admincreds
        }

        Script GrantSysAdmin
        {
            SetScript =
            {
                $RawAccount = "$using:NetBiosDomain\$using:InstallAccount"
                $Account = "'"+$RawAccount+"'"
                $Role = "'sysadmin'"
                sqlcmd -S "$using:computername" -q "exec sp_addsrvrolemember $Account, $Role"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $Admincreds
            DependsOn = '[SqlLogin]CreateInstallSQLLogin'
        }

        SqlPermission 'GRANTSYSTEM'
        {
            Ensure               = 'Present'
            ServerName           = "$ComputerName.$DomainName"
            InstanceName         = 'MSSQLSERVER'
            Principal            = 'NT AUTHORITY\SYSTEM'
            Permission           = 'AlterAnyAvailabilityGroup', 'ConnectSql','ViewServerState'
            PsDscRunAsCredential = $Admincreds
            DependsOn = '[Script]GrantSysAdmin'
        }

        SqlServiceAccount 'SetServiceAccount'
        {
            ServerName     = "$ComputerName.$DomainName"
            InstanceName   = 'MSSQLSERVER'
            ServiceType    = 'DatabaseEngine'
            ServiceAccount = $Sqlsvc
            RestartService = $true
        }

        WindowsFeature Failover-Clustering
        {
            Ensure = 'Present'
            Name = 'Failover-Clustering'
        }
        
        WindowsFeature RSAT-Clustering
        {
            Ensure = 'Present'
            Name = 'RSAT-Clustering'
            IncludeAllSubFeature = $true
        }

       Script AllowLBProbe
        {
            SetScript =
            {
                $firewall = Get-NetFirewallRule "Azure LB Probe" -ErrorAction 0
                IF ($firewall -ne $null) {New-NetFirewallRule -DisplayName "Azure LB Probe" -Direction Inbound -LocalPort 1433,59999,5022 -Protocol TCP -Action Allow}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }
    }
}