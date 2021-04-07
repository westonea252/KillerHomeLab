@description('Computer Name')
param computerName string

@description('Time Zone')
param TimeZone string

@description('SQL Host Name')
param SQLHost string

@description('Root domain FQDN')
param ExternaldomainName string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Issuing CA Name')
param IssuingCAName string

@description('Root CA Name')
param RootCAName string

@description('Primary ADFS IP')
param PrimaryADFSServerIP string

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('Region of Resources')
param location string

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param artifactsLocation string

@description('Auto-generated token to access _artifactsLocation')
@secure()
param artifactsLocationSasToken string

var ModulesURL = uri(artifactsLocation, 'DSC/OTHERADFSwithSQL.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'OTHERADFSwithSQL.ps1\\OTHERADFSwithSQL'

resource computerName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: ModulesURL
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        TimeZone: TimeZone
        SQLHost: SQLHost
        ExternaldomainName: ExternaldomainName
        NetBiosDomain: NetBiosDomain
        IssuingCAName: IssuingCAName
        RootCAName: RootCAName
        PrimaryADFSServerIP: PrimaryADFSServerIP
        AdminCreds: {
          UserName: adminUsername
          Password: 'PrivateSettingsRef:AdminPassword'
        }
      }
    }
    protectedSettings: {
      Items: {
        AdminPassword: adminPassword
      }
    }
  }
}