@description('Computer Name')
param computerName string

@description('Time Zone')
param TimeZone string

@description('Certificate Authority Name')
param RootCAName string

@description('Offline Root CA Algorithm')
param RootCAHashAlgorithm string = ''

@description('Offline Root CA Key Length')
param RootCAKeyLength string = ''

@description('Root Domain Name FQDN')
param domainName string

@description('Base Domain Distiguished Name')
param BaseDN string

@description('Region of Resources')
param location string

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param artifactsLocation string

@description('Auto-generated token to access _artifactsLocation')
@secure()
param artifactsLocationSasToken string

var ModulesURL = uri(artifactsLocation, 'DSC/ROOTCA.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'ROOTCA.ps1\\ROOTCA'

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
        domainName: domainName
        RootCAName: RootCAName
        RootCAHashAlgorithm: RootCAHashAlgorithm
        RootCAKeyLength: RootCAKeyLength
        BaseDN: BaseDN
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