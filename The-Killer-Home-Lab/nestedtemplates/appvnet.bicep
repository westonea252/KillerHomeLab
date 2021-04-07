param vnetName string = 'KHL-VNet1'
param vnetprefix string = '10.1.0.0/16'
param subnet1Name string = 'KHL-VNet1-Subnet1'
param subnet1Prefix string = '10.1.1.0/24'
param subnet2Name string = 'KHL-VNet1-Subnet2'
param subnet2Prefix string = '10.1.2.0/24'
param subnet3Name string = 'KHL-VNet1-Subnet3'
param subnet3Prefix string = '10.1.3.0/24'
param subnet4Name string = 'KHL-VNet1-Subnet4'
param subnet4Prefix string = '10.1.4.0/24'
param subnet5Name string = 'KHL-VNet1-Subnet5'
param subnet5Prefix string = '10.1.5.0/24'
param subnet6Name string = 'KHL-VNet1-Subnet6'
param subnet6Prefix string = '10.1.6.0/24'
param subnet7Name string = 'KHL-VNet1-Subnet7'
param subnet7Prefix string = '10.1.7.0/24'
param location string = 'EastUS'


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
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
        }
      }
      {
        name: subnet4Name
        properties: {
          addressPrefix: subnet4Prefix
        }
      }
      {
        name: subnet5Name
        properties: {
          addressPrefix: subnet5Prefix
        }
      }
      {
        name: subnet6Name
        properties: {
          addressPrefix: subnet6Prefix
        }
      }
      {
        name: subnet7Name
        properties: {
          addressPrefix: subnet7Prefix
        }
      }
    ]
  }
}

output vnetName string = vnetName
