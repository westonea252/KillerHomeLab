@description('Computer Name')
param computerName string

@description('Root CA IP')
param RootCAIP string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Issuing CA Name')
param IssuingCAName string

@description('Certificate Authority Name')
param RootCAName string

@description('Root Domain Name FQDN')
param domainName string

@description('URL to PowerShell Script for CA Template Creation')
param CATemplateScriptUrl string

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

var ModulesURL = uri(artifactsLocation, 'DSC/FINALIZECA.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'FINALIZECA.ps1\\FINALIZECA'

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
        RootCAIP: RootCAIP
        NetBiosDomain: NetBiosDomain
        IssuingCAName: IssuingCAName
        RootCAName: RootCAName
        domainName: domainName
        CATemplateScriptUrl: CATemplateScriptUrl
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