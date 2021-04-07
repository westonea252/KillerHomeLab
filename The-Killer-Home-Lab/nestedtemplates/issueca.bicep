@description('Computer Name')
param computerName string

@description('Time Zone')
param TimeZone string

@description('Domain Naming Convention')
param NamingConvention string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Issuing CA Name')
param IssuingCAName string

@description('Certificate Authority Name')
param RootCAName string

@description('Root CA IP')
param RootCAIP string

@description('Issuing CA Algorithm')
param IssuingCAHashAlgorithm string = ''

@description('Issuing CA Key Length')
param IssuingCAKeyLength string = ''

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

var ModulesURL = uri(artifactsLocation, 'DSC/ISSUECA.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'ISSUECA.ps1\\ISSUECA'

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
        computerName: computerName
        TimeZone: TimeZone
        NamingConvention: NamingConvention
        NetBiosDomain: NetBiosDomain
        IssuingCAName: IssuingCAName
        RootCAName: RootCAName
        RootCAIP: RootCAIP
        IssuingCAHashAlgorithm: IssuingCAHashAlgorithm
        IssuingCAKeyLength: IssuingCAKeyLength
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
