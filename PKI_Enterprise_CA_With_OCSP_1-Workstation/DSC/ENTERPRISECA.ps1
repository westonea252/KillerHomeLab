Configuration ENTERPRISECA
{
   param
   (
        [String]$NetBiosDomain,
        [String]$rootdomainfqdn,
        [String]$EnterpriseCAHashAlgorithm,
        [String]$EnterpriseCAKeyLength,
        [String]$EnterpriseCAName,
        [System.Management.Automation.PSCredential]$Admincreds
    )
 
    Import-DscResource -Module ComputerManagementDsc
    Import-DscResource -Module ActiveDirectoryCSDsc

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($AdminCreds.UserName)", $AdminCreds.Password)
 
    Node localhost
    {
        # Assemble the Local Admin Credentials
        # Install the ADCS Certificate Authority
        WindowsFeature ADCSCA 
        {
            Name = 'ADCS-Cert-Authority'
            Ensure = 'Present'
        }

        File CertEnroll
        {
            Type = 'Directory'
            DestinationPath = 'C:\CertEnroll'
            Ensure = "Present"
        }

        File MachineConfig
        {
            Type = 'Directory'
            DestinationPath = 'C:\MachineConfig'
            Ensure = "Present"
        }

        # Configure the CA as Enterprise Root CA
        ADCSCertificationAuthority CertificateAuthority
        {
            Ensure = 'Present'
	        Credential = $DomainCreds
            CAType = 'EnterpriseRootCA'
            CACommonName = $EnterpriseCAName
            CADistinguishedNameSuffix = $Node.CADistinguishedNameSuffix
            ValidityPeriod = 'Years'
            ValidityPeriodUnits = 20
            CryptoProviderName = 'RSA#Microsoft Software Key Storage Provider'
            HashAlgorithmName = $EnterpriseCAHashAlgorithm
            KeyLength = $EnterpriseCAKeyLength
            IsSingleInstance = 'Yes'
            DependsOn = "[WindowsFeature]ADCSCA"
        }

        # Configure the Web Enrollment Feature
        ADCSWebEnrollment ConfigWebEnrollment
        {
            Ensure = 'Present'
            Credential = $DomainCreds
            IsSingleInstance = 'Yes'
            DependsOn = '[AdcsCertificationAuthority]CertificateAuthority'
        }

        WindowsFeature RSAT-ADCS 
        { 
            Ensure = 'Present' 
            Name = 'RSAT-ADCS' 
            DependsOn = '[AdcsWebEnrollment]ConfigWebEnrollment'
        } 

        WindowsFeature Web-Mgmt-Console
        { 
            Ensure = 'Present' 
            Name = 'Web-Mgmt-Console' 
            DependsOn = '[AdcsWebEnrollment]ConfigWebEnrollment'
        }

        WindowsFeature RSAT-ADCS-Mgmt 
        { 
            Ensure = 'Present' 
            Name = 'RSAT-ADCS-Mgmt' 
            DependsOn = '[AdcsCertificationAuthority]CertificateAuthority'
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
                # Remove All Default CDP Locations
                Get-CACrlDistributionPoint | Where-Object {$_.Uri -like 'ldap*'} | Remove-CACrlDistributionPoint -Force
                Get-CACrlDistributionPoint | Where-Object {$_.Uri -like 'http*'} | Remove-CACrlDistributionPoint -Force
                Get-CACrlDistributionPoint | Where-Object {$_.Uri -like 'file*'} | Remove-CACrlDistributionPoint -Force

                # Check for and if not present add LDAP CDP Location
                $LDAPCDPURI = Get-CACrlDistributionPoint | Where-object {$_.uri -like "ldap:///CN=<CATruncatedName><CRLNameSuffix>"+"*"}
                IF ($LDAPCDPURI.uri -eq $null){Add-CACRLDistributionPoint -Uri "ldap:///CN=<CATruncatedName><CRLNameSuffix>,CN=<ServerShortName>,CN=CDP,CN=Public Key Services,CN=Services,<ConfigurationContainer><CDPObjectClass>" -PublishToServer -AddToCertificateCDP -AddToCrlCdp -Force}

                # Check for and if not present add HTTP CDP Location
                $HTTPCDPURI = Get-CACrlDistributionPoint | Where-object {$_.uri -like "http://crl"+"*"}
                IF ($HTTPCDPURI.uri -eq $null){Add-CACRLDistributionPoint -Uri "http://crl.$using:rootdomainfqdn/CertEnroll/<CAName><CRLNameSuffix><DeltaCRLAllowed>.crl" -AddToCertificateCDP -AddToFreshestCrl -Force}

                # Remove All Default AIA Locations
                Get-CAAuthorityInformationAccess | Where-Object {$_.Uri -like 'ldap*'} | Remove-CAAuthorityInformationAccess -Force
                Get-CAAuthorityInformationAccess | Where-Object {$_.Uri -like 'http*'} | Remove-CAAuthorityInformationAccess -Force
                Get-CAAuthorityInformationAccess | Where-Object {$_.Uri -like 'file*'} | Remove-CAAuthorityInformationAccess -Force

                # Check for and if not present add LDAP AIA Location
                $LDAPAIAURI = Get-CAAuthorityInformationaccess | Where-object {$_.uri -like "ldap:///CN=<CATruncatedName>,CN=AIA"+"*"}
                IF ($LDAPAIAURI.uri -eq $null){Add-CAAuthorityInformationaccess -Uri "ldap:///CN=<CATruncatedName>,CN=AIA,CN=Public Key Services,CN=Services,<ConfigurationContainer><CAObjectClass>" -AddToCertificateAia -Force}

                # Check for and if not present add HTTP AIA Location
                $HTTPAIAURI = Get-CAAuthorityInformationaccess | Where-object {$_.uri -like "http://crl"+"*"}
                IF ($HTTPAIAURI.uri -eq $null){Add-CAAuthorityInformationaccess -Uri "http://ocsp.$rootdomainfqdn/ocsp" -AddToCertificateOcsp -Force}

                Restart-Service -Name CertSvc 
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[AdcsCertificationAuthority]CertificateAuthority'
        }
   
     }
  }