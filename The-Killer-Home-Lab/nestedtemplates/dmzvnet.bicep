@description('VNet name')
param vnetName string

@description('VNet prefix')
param vnetprefix string

@description('Subnet 1 Name')
param subnet1Name string

@description('Subnet 1 Prefix')
param subnet1Prefix string

@description('Bastion Subnet Prefix')
param BastionsubnetPrefix string

@description('Firewall Subnet Prefix')
param FirewallsubnetPrefix string

@description('Region of Resources')
param location string

resource vnetName_resource 'Microsoft.Network/virtualNetworks@2020-04-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetprefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: BastionsubnetPrefix
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: FirewallsubnetPrefix
        }
      }
    ]
  }
}

output vnetName string = vnetName