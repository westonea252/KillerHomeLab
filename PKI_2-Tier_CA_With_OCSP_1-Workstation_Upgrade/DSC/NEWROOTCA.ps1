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
 
    Node localhost
    {
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
	        Credential = $Admincreds
            CAType = 'StandaloneRootCA'
            IsSingleInstance = 'Yes'
            CertFile = "C:\CARestore\$RootCAName.p12"
            DependsOn = '[Script]ImportRootCA','[WindowsFeature]ADCSCA'
            PsDscRunAsCredential = $Admincreds
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
            PsDscRunAsCredential = $Admincreds
            DependsOn = '[AdcsCertificationAuthority]CertificateAuthority'
        }
   
     }
  }