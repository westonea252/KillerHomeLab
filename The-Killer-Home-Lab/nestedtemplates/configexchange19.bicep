@description('Computer Name')
param computerName string

@description('The FQDN of the AD Domain created ')
param InternaldomainName string

@description('The External FQDN of the AD Domain created ')
param ExternaldomainName string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Base Domain Distiguished Name')
param BaseDN string

@description('Site 2 Domain Controller Name')
param Site1DC string

@description('Site 2 Domain Controller Name')
param Site2DC string

@description('Domain Controller used for Exchange Config')
param ConfigDC string

@description('CA Server IP')
param CAServerIP string

@description('Site Name')
param Site string

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

var ModulesURL = uri(artifactsLocation, 'DSC/CONFIGEXCHANGE19.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'CONFIGEXCHANGE19.ps1\\CONFIGEXCHANGE19'

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
        ComputerName: computerName
        InternaldomainName: InternaldomainName
        ExternaldomainName: ExternaldomainName
        NetBiosDomain: NetBiosDomain
        BaseDN: BaseDN
        Site1DC: Site1DC
        Site2DC: Site2DC
        ConfigDC: ConfigDC
        CAServerIP: CAServerIP
        Site: Site
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