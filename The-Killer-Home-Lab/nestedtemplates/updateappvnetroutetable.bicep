@description('VNet name')
param vnetName string

@description('VNet prefix')
param vnetprefix string

@description('Subnet 1 Name')
param subnet1Name string

@description('Subnet 1 Prefix')
param subnet1Prefix string

@description('Subnet 2 Name')
param subnet2Name string

@description('Subnet 2 Prefix')
param subnet2Prefix string

@description('Subnet 3 Name')
param subnet3Name string

@description('Subnet 3 Prefix')
param subnet3Prefix string

@description('Subnet 4 Name')
param subnet4Name string

@description('Subnet 4 Prefix')
param subnet4Prefix string

@description('Subnet 5 Name')
param subnet5Name string

@description('Subnet 5 Prefix')
param subnet5Prefix string

@description('Subnet 6 Name')
param subnet6Name string

@description('Subnet 6 Prefix')
param subnet6Prefix string

@description('Route Table Name')
param RouteTableName string

@description('Subnet 7 Name')
param subnet7Name string

@description('Subnet 7 Prefix')
param subnet7Prefix string

@description('Region of Resources')
param location string

var RouteTableId = resourceId(resourceGroup().name, 'Microsoft.Network/routeTables', RouteTableName)

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
          routeTable: {
            id: RouteTableId
          }
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
          routeTable: {
            id: RouteTableId
          }
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
          routeTable: {
            id: RouteTableId
          }
        }
      }
      {
        name: subnet4Name
        properties: {
          addressPrefix: subnet4Prefix
          routeTable: {
            id: RouteTableId
          }
        }
      }
      {
        name: subnet5Name
        properties: {
          addressPrefix: subnet5Prefix
          routeTable: {
            id: RouteTableId
          }
        }
      }
      {
        name: subnet6Name
        properties: {
          addressPrefix: subnet6Prefix
          routeTable: {
            id: RouteTableId
          }
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