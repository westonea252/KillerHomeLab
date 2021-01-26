Configuration NEWROOTCA
{
   param
   (
        [String]$RootDomainFQDN,
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
                # Import Root CA
                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {$_.Subject -like "CN=$using:RootCAName"}).Thumbprint
                IF ($thumbprint -eq $null) {Import-PfxCertificate -FilePath "C:\CARestore\$using:RootCAName.p12" -CertStoreLocation cert:\LocalMachine\Root}
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

        # Configure the CA as Standalone Root CA from .p12
        ADCSCertificationAuthority CertificateAuthority
        {
            Ensure = 'Present'
	        Credential = $Creds	
            CAType = 'StandaloneRootCA'
            IsSingleInstance = 'Yes'
            CertFile = "C:\CARestore\$RootCAName.p12"
            CertFilePassword = $null
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
                $RestoreCheck = Get-ChildItem -Path "C:\CARestore\RestoreStatus.txt" -ErrorAction 0
                IF ($RestoreCheck -eq $null) { 

                # Stop CA Service
                Stop-Service -Name CertSvc

                # Restore CA Database
                Restore-CARoleService –path C:\CARestore -DatabaseOnly -Force

                # Restore Registry
                reg import "C:\CARestore\$using:RootCAName.reg"

                # Restore Successful
                Set-Content -Path C:\CARestore\RestoreStatus.txt -Value 'Restore Successful'

                # Start CA Service
                Start-Service -Name CertSvc
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[AdcsCertificationAuthority]CertificateAuthority'
        }
   
     }
  }