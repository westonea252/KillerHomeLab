@description('Set the local VNet name')
param SourceVNetName string

@description('Set the remote VNet name')
param TargetVNetName string

@description('Boolean value (true or false) without quotes')
param allowVirtualNetworkAccess bool

@description('Boolean value (true or false) without quotes')
param allowForwardedTraffic bool

@description('Boolean value (true or false) without quotes')
param allowGatewayTransit bool

@description('Boolean value (true or false) without quotes')
param useRemoteGateways bool

@description('Location for all resources.')
param location string

var remoteVNet = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', TargetVNetName)
var peeringName_var = '${SourceVNetName}/${SourceVNetName}-to-${TargetVNetName}'

resource peeringName 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2019-09-01' = {
  name: peeringName_var
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVNet
    }
  }
}
