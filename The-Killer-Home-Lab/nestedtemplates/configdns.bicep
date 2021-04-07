@description('Computer Name')
param computerName string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('The FQDN of the AD Domain created ')
param InternaldomainName string

@description('The External FQDN of the AD Domain created ')
param ExternaldomainName string

@description('The name of Reverse Lookup Zone 1 Network ID')
param ReverseLookup1 string

@description('The name of Reverse Lookup Zone 2 Network ID')
param ReverseLookup2 string

@description('DC1 Last IP Octet')
param dc1lastoctet string

@description('DC2 Last IP Octet')
param dc2lastoctet string

@description('Exchange Server1 IP')
param ex1IP string

@description('Exchange Server2 IP')
param ex2IP string

@description('Issuing CA IP')
param icaIP string

@description('OCSP IP')
param ocspIP string

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

var ModulesURL = uri(artifactsLocation, 'DSC/CONFIGDNS.zip${artifactsLocationSasToken}')
var ConfigurationFunction = 'CONFIGDNS.ps1\\CONFIGDNS'

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
        NetBiosDomain: NetBiosDomain
        InternaldomainName: InternaldomainName
        ExternaldomainName: ExternaldomainName
        ReverseLookup1: ReverseLookup1
        ReverseLookup2: ReverseLookup2
        dc1lastoctet: dc1lastoctet
        dc2lastoctet: dc2lastoctet
        icaIP: icaIP
        ocspIP: ocspIP
        ex1IP: ex1IP
        ex2IP: ex2IP
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