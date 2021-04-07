@description('Firewall Private IP')
param FirewallIP string

@description('Route Table Name')
param RouteTableName string

@description('Specifies the location in which to create the workspace.')
param location string

resource RouteTableName_resource 'Microsoft.Network/routeTables@2020-05-01' = {
  name: RouteTableName
  location: location
  properties: {
    routes: [
      {
        name: 'Internet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: FirewallIP
        }
      }
    ]
    disableBgpRoutePropagation: true
  }
}