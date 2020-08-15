configuration CONFIGEXCHANGE10
{
   param
   (
        [String]$ComputerName,
        [String]$RootDomainFQDN,                
        [String]$NetBiosDomain,
        [String]$BaseDN,
        [String]$Site1DC,
        [String]$Site2DC,
        [String]$ConfigDC,
        [String]$Site1FSW,
        [String]$DAGName,
        [String]$DAGIPAddress,
        [String]$CAServerIP,
        [String]$Site,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        File Certificates
        {
            Type = 'Directory'
            DestinationPath = 'C:\Certificates'
            Ensure = "Present"
        }

        Script ConfigureCertificate
        {
            SetScript =
            {
                # Create Credentials
                $Load = "$using:DomainCreds"
                $Password = $DomainCreds.Password

                # Get Certificate 2010 Certificate
                $CertCheck = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=owa2010.$using:RootDomainFQDN"}
                IF ($CertCheck -eq $Null) {Get-Certificate -Template WebServer1 -SubjectName "CN=owa2010.$using:RootDomainFQDN" -DNSName "owa2010.$using:RootDomainFQDN","autodiscover2010.$using:RootDomainFQDN","autodiscover.$using:RootDomainFQDN","outlook2010.$using:RootDomainFQDN","eas2010.$using:RootDomainFQDN" -CertStoreLocation "cert:\LocalMachine\My"}

                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=owa2010.$using:RootDomainFQDN"}).Thumbprint
                (Get-ChildItem -Path Cert:\LocalMachine\My\$thumbprint).FriendlyName = "Exchange 2010 SAN Cert"

                # Export Service Communication Certificate
                $CertFile = Get-ChildItem -Path "C:\Certificates\owa2010.$using:RootDomainFQDN.pfx" -ErrorAction 0
                IF ($CertFile -eq $Null) {Get-ChildItem -Path cert:\LocalMachine\my\$thumbprint | Export-PfxCertificate -FilePath "C:\Certificates\owa2010.$using:RootDomainFQDN.pfx" -Password $Password}

                # Share Certificate
                $CertShare = Get-SmbShare -Name Certificates -ErrorAction 0
                IF ($CertShare -eq $Null) {New-SmbShare -Name Certificates -Path C:\Certificates -FullAccess Administrators}
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]Certificates'
        }

        Script ConfigureExchange2010
        {
            SetScript =
            {
                repadmin /replicate "$using:Site1DC" "$using:Site2DC" "$using:BaseDN"
                repadmin /replicate "$using:Site2DC" "$using:Site1DC" "$using:BaseDN"

                # Get Certificate 2010 Certificate
                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=owa2010.$using:RootDomainFQDN"}).Thumbprint

                # Set Virtual Directories
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$using:computername.$using:RootDomainFQDN/PowerShell/"
                Import-PSSession $Session
                Set-ClientAccessServer "$using:computername" –AutodiscoverServiceInternalUri "https://autodiscover2010.$using:RootDomainFQDN/Autodiscover/Autodiscover.xml"
                Set-OWAVirtualDirectory –Identity "$using:computername\owa (Default Web Site)" –InternalURL "https://owa2010.$using:RootDomainFQDN/OWA" -ExternalURL "https://owa2010.$using:RootDomainFQDN/OWA" -ExternalAuthenticationMethods NTLM -FormsAuthentication:$False -BasicAuthentication:$False –WindowsAuthentication:$True
                Set-ECPVirtualDirectory –Identity "$using:computername\ecp (Default Web Site)" –InternalURL "https://owa2010.$using:RootDomainFQDN/ECP" -ExternalURL "https://owa2010.$using:RootDomainFQDN/ECP" -ExternalAuthenticationMethods NTLM -FormsAuthentication:$False -BasicAuthentication:$False –WindowsAuthentication:$True
                Set-OABVirtualDirectory –Identity "$using:computername\oab (Default Web Site)" –InternalURL "https://outlook2010.$using:RootDomainFQDN/OAB" -ExternalURL "https://outlook2010.$using:RootDomainFQDN/OAB"
                Set-WebServicesVirtualDirectory –Identity "$using:computername\EWS (Default Web Site)" –MRSProxyEnabled:$True
                Set-ActiveSyncVirtualDirectory –Identity "$using:computername\Microsoft-Server-ActiveSync (Default Web Site)" –InternalURL "https://eas2010.$using:RootDomainFQDN/Microsoft-Server-ActiveSync" -ExternalURL "https://eas2010.$using:RootDomainFQDN/Microsoft-Server-ActiveSync"
                Set-WebServicesVirtualDirectory –Identity "$using:computername\EWS (Default Web Site)" –InternalURL "https://outlook2010.$using:RootDomainFQDN/EWS/Exchange.asmx" -ExternalURL "https://outlook2010.$using:RootDomainFQDN/EWS/Exchange.asmx"

                # Enable Exchange 2010 Certificate
                Enable-ExchangeCertificate -Thumbprint $thumbprint -Services IIS -Confirm:$False

                # Create DAG
                Start-Sleep -s 60
                $DAGCheck = Get-DatabaseAvailabilityGroup -Identity "$using:DAGName" -DomainController "$using:ConfigDC" -ErrorAction 0
                IF ($DAGCheck -eq $null) {New-DatabaseAvailabilityGroup -Name "$using:DAGName" -WitnessServer "$using:Site1FSW" -WitnessDirectory C:\FSWs -DomainController "$using:ConfigDC"}
                Set-DatabaseAvailabilityGroup -Identity "$using:DAGName" -DatabaseAvailabilityGroupIpAddresses "$using:DAGIPAddress" -DomainController "$using:ConfigDC"
                Add-DatabaseAvailabilityGroupServer -Identity "$using:DAGName" -MailboxServer "$using:computername" -DomainController "$using:ConfigDC"

                # Create Connectors
                $LocalRelayRecieveConnector = Get-ReceiveConnector "LocalRelay $using:computerName" -DomainController "$using:ConfigDC" -ErrorAction 0
                IF ($LocalRelayRecieveConnector -eq $Null) {
                New-ReceiveConnector "LocalRelay $using:computerName" -Custom -Bindings 0.0.0.0:25 -RemoteIpRanges "$using:CAServerIP" -DomainController "$using:ConfigDC"
                Get-ReceiveConnector "LocalRelay $using:computerName" -DomainController "$using:ConfigDC" | Add-ADPermission -User "NT AUTHORITY\ANONYMOUS LOGON" -ExtendedRights "Ms-Exch-SMTP-Accept-Any-Recipient" -ErrorAction 0
                Set-ReceiveConnector "LocalRelay $using:computerName" -AuthMechanism ExternalAuthoritative -PermissionGroups ExchangeServers
                }

                $InternetSendConnector = Get-SendConnector "$using:Site Internet" -ErrorAction 0
                IF ($InternetSendConnector -eq $Null) {
                New-SendConnector "$using:Site Internet" -AddressSpaces * -SourceTransportServers "$using:computerName"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }
    }
}