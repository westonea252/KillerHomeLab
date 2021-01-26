Configuration NEWROOTCA
{
   param
   (
        [String]$RootDomainFQDN,
        [String]$RootCAHashAlgorithm,
        [String]$RootCAKeyLength,
        [String]$RootCAName,
        [String]$BaseDN,
        [System.Management.Automation.PSCredential]$Admincreds
    )
 
    Import-DscResource -Module ComputerManagementDsc
    Import-DscResource -Module ActiveDirectoryCSDsc
    Import-DscResource -Module xPSDesiredStateConfiguration

    [System.Management.Automation.PSCredential ]$Creds = New-Object System.Management.Automation.PSCredential ("$($AdminCreds.UserName)", $AdminCreds.Password)
 
    Node localhost
    {
        Script ImportRootCA
        {
            SetScript =
            {
                # Import CA
                Import-Certificate -FilePath "C:\CARestore\$using:RootCAName.p7b" -CertStoreLocation cert:\LocalMachine\Root

                # Restore CA Database
                Restore-CARoleService –path C:\CARestore -DatabaseOnly -Force

                # Start CA Service
                Start-Service -Name CertSvc

                # Stop CA Service
                Stop-Service -Name CertSvc

                # Restore Registry
                reg import "C:\CARestore\$using:RootCAName.reg"
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

        # Assemble the Local Admin Credentials
        # Install the ADCS Certificate Authority
        WindowsFeature ADCSCA 
        {
            Name = 'ADCS-Cert-Authority'
            Ensure = 'Present'
        }

        # Configure the CA as Standalone Root CA
        ADCSCertificationAuthority CertificateAuthority
        {
            Ensure = 'Present'
	        Credential = $Creds	
            CAType = 'StandaloneRootCA'
            CACommonName = $RootCAName
            CADistinguishedNameSuffix = $Node.CADistinguishedNameSuffix
            ValidityPeriod = 'Years'
            ValidityPeriodUnits = 20
            CryptoProviderName = 'RSA#Microsoft Software Key Storage Provider'
            HashAlgorithmName = $RootCAHashAlgorithm
            KeyLength = $RootCAKeyLength
            IsSingleInstance = 'Yes'
            DependsOn = '[Script]ImportRootCA','[WindowsFeature]ADCSCA'
        }
 
        WindowsFeature RSAT-ADCS 
        { 
            Name = 'RSAT-ADCS' 
            Ensure = 'Present'
            DependsOn = "[WindowsFeature]ADCSCA"
        } 

        WindowsFeature RSAT-ADCS-Mgmt 
        { 
            Name = 'RSAT-ADCS-Mgmt' 
            Ensure = 'Present' 
            DependsOn = "[WindowsFeature]ADCSCA"
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }

        Script ConfigureRootCA
        {
            SetScript =
            {
                # Stop CA Service
                Stop-Service -Name CertSvc

                # Restore CA Database
                Restore-CARoleService –path C:\CARestore -DatabaseOnly -Force

                # Start CA Service
                Start-Service -Name CertSvc

                # Stop CA Service
                Stop-Service -Name CertSvc

                # Restore Registry
                reg import "C:\CARestore\$using:RootCAName.reg"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[AdcsCertificationAuthority]CertificateAuthority'
        }
   
     }
  }