@description('Computer Name')
param computerName string

@description('Domain Naming Convention')
param NamingConvention string

@description('Issuing CA Name')
param IssuingCAName string

@description('Offline Root CA Name')
param RootCAName string

@description('Region of Resources')
param location string

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param artifactsLocation string

@description('Auto-generated token to access _artifactsLocation')
@secure()
param artifactsLocationSasToken string

var ModulesURL = uri(artifactsLocation, 'DSC/GRANTCA.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'GRANTCA.ps1\\GRANTCA'

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
        NamingConvention: NamingConvention
        IssuingCAName: IssuingCAName
        RootCAName: RootCAName
      }
    }
  }
}