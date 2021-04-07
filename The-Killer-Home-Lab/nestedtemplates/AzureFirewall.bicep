@description('Resource Group Name')
param FirewallName string

@description('Existing VNET Name that contains the domain controller')
param vnetName string

@description('APP VNet1 Address Prefix')
param APPVNet1Prefix string

@description('APP VNet2 Address Prefix')
param APPVNet2Prefix string

@description('DMZ VNet1 Address Prefix')
param DMZVNet1Prefix string

@description('DMZ VNet2 Address Prefix')
param DMZVNet2Prefix string

@description('Existing subnet name that contains the domain controller')
param subnetName string

@description('Web IP')
param webIP string

@description('OCSP IP')
param OCSPIP string

@description('WAP IP')
param WAPIP string

@description('SMTP IP')
param SMTPIP string

@description('Specifies the location in which to create the workspace.')
param location string

var publicIPAddressName_var = '${FirewallName}-pip'
var webpublicIPAddressName_var = '${FirewallName}-web-pip'
var ocsppublicIPAddressName_var = '${FirewallName}-ocsp-pip'
var wappublicIPAddressName_var = '${FirewallName}-wap-pip'
var smtppublicIPAddressName_var = '${FirewallName}-smtp-pip'
var subnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource publicIPAddressName 'Microsoft.Network/publicIPAddresses@2018-11-01' = {
  name: publicIPAddressName_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource webpublicIPAddressName 'Microsoft.Network/publicIPAddresses@2018-11-01' = {
  name: webpublicIPAddressName_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource ocsppublicIPAddressName 'Microsoft.Network/publicIPAddresses@2018-11-01' = {
  name: ocsppublicIPAddressName_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource wappublicIPAddressName 'Microsoft.Network/publicIPAddresses@2018-11-01' = {
  name: wappublicIPAddressName_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource smtppublicIPAddressName 'Microsoft.Network/publicIPAddresses@2018-11-01' = {
  name: smtppublicIPAddressName_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource FirewallName_resource 'Microsoft.Network/azureFirewalls@2020-04-01' = {
  name: FirewallName
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    ipConfigurations: [
      {
        name: 'PrimaryIPConfiguration'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIPAddressName.id
          }
        }
      }
      {
        name: 'WEB'
        properties: {
          publicIPAddress: {
            id: webpublicIPAddressName.id
          }
        }
      }
      {
        name: 'OCSP'
        properties: {
          publicIPAddress: {
            id: ocsppublicIPAddressName.id
          }
        }
      }
      {
        name: 'WAP'
        properties: {
          publicIPAddress: {
            id: wappublicIPAddressName.id
          }
        }
      }
      {
        name: 'SMTP'
        properties: {
          publicIPAddress: {
            id: smtppublicIPAddressName.id
          }
        }
      }
    ]
    networkRuleCollections: [
      {
        name: 'Internal-Traffic'
        properties: {
          priority: 100
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'Site1-To-Site2'
              description: 'string'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                APPVNet1Prefix
                APPVNet2Prefix
                DMZVNet1Prefix
                DMZVNet2Prefix
              ]
              destinationAddresses: [
                APPVNet1Prefix
                APPVNet2Prefix
                DMZVNet1Prefix
                DMZVNet2Prefix
              ]
              destinationPorts: [
                '*'
              ]
            }
          ]
        }
      }
    ]
    applicationRuleCollections: [
      {
        name: 'Allowed-Sites'
        properties: {
          priority: 100
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'Azure-Portals'
              protocols: [
                {
                  protocolType: 'Http'
                  port: 80
                }
                {
                  protocolType: 'Https'
                  port: 443
                }
              ]
              targetFqdns: [
                'portal.azure.com'
                'portal.azure.us'
              ]
              sourceAddresses: [
                '*'
              ]
            }
            {
              name: 'Deployment-Downloads'
              protocols: [
                {
                  protocolType: 'Http'
                  port: 80
                }
                {
                  protocolType: 'Https'
                  port: 443
                }
              ]
              targetFqdns: [
                'raw.githubusercontent.com'
                'github.com'
                '*.blob.core.windows.net'
                'aka.ms'
                'redirectiontool.trafficmanager.net'
                '*.microsoft.com'
              ]
              sourceAddresses: [
                '*'
              ]
            }
            {
              name: 'WindowsUpdate'
              protocols: [
                {
                  protocolType: 'Http'
                  port: 80
                }
                {
                  protocolType: 'Https'
                  port: 443
                }
              ]
              fqdnTags: [
                'WindowsUpdate'
              ]
              sourceAddresses: [
                '*'
              ]
            }
          ]
        }
      }
    ]
    natRuleCollections: [
      {
        name: 'Inbound-Traffic'
        properties: {
          priority: 100
          action: {
            type: 'Dnat'
          }
          rules: [
            {
              name: 'Web-Inbound'
              protocols: [
                'TCP'
              ]
              translatedAddress: webIP
              translatedPort: '80'
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                webpublicIPAddressName.properties.ipAddress
              ]
              destinationPorts: [
                '80'
              ]
            }
            {
              name: 'OCSP-Inbound'
              protocols: [
                'TCP'
              ]
              translatedAddress: OCSPIP
              translatedPort: '80'
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                ocsppublicIPAddressName.properties.ipAddress
              ]
              destinationPorts: [
                '80'
              ]
            }
            {
              name: 'OWA-Inbound'
              protocols: [
                'TCP'
              ]
              translatedAddress: WAPIP
              translatedPort: '443'
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                wappublicIPAddressName.properties.ipAddress
              ]
              destinationPorts: [
                '443'
              ]
            }
            {
              name: 'SMTP-Inbound'
              protocols: [
                'TCP'
              ]
              translatedAddress: SMTPIP
              translatedPort: '25'
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                smtppublicIPAddressName.properties.ipAddress
              ]
              destinationPorts: [
                '25'
              ]
            }
          ]
        }
      }
    ]
  }
}

output WebPublicIP string = reference(resourceId(resourceGroup().name, 'Microsoft.Network/publicIPAddresses', webpublicIPAddressName_var)).ipAddress
output OCSPPublicIP string = reference(resourceId(resourceGroup().name, 'Microsoft.Network/publicIPAddresses', ocsppublicIPAddressName_var)).ipAddress
output WAPPublicIP string = reference(resourceId(resourceGroup().name, 'Microsoft.Network/publicIPAddresses', wappublicIPAddressName_var)).ipAddress
output SMTPPublicIP string = reference(resourceId(resourceGroup().name, 'Microsoft.Network/publicIPAddresses', smtppublicIPAddressName_var)).ipAddress