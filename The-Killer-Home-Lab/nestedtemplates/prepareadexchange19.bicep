@description('Computer Name')
param computerName string

@description('Exchange Organization Name')
param ExchangeOrgname string

@description('Domain Controller 1 Name')
param DC1Name string

@description('Domain Controller 2 Name')
param DC2Name string

@description('Base Domain Distiguished Name')
param BaseDN string

@description('NetBios Domain Name')
param NetBiosDomain string

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

var ModulesURL = uri(artifactsLocation, 'DSC/PREPAREADEXCHANGE19.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'PREPAREADEXCHANGE19.ps1\\PREPAREADEXCHANGE19'

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
        ExchangeOrgName: ExchangeOrgname
        NetBiosDomain: NetBiosDomain
        DC1Name: DC1Name
        DC2Name: DC2Name
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