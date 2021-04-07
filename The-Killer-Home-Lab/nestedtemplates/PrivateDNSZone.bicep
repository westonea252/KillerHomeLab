@description('DNS Zone Name')
param ZoneName string

@description('Existing DMZ VNET1 Name')
param vnet1Name string

@description('Existing DMZ VNET2 Name')
param vnet2Name string

@description('ADFS Internal DNS Record')
param ADFSRecord string

@description('ADFS1 Internal IP')
param ADFS1PrivateIP string

@description('ADFS2 Internal IP')
param ADFS2PrivateIP string

resource ZoneName_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: ZoneName
  location: 'global'
  tags: {}
  properties: {
    registrationVirtualNetworks: [
      {
        id: resourceId('Microsoft.Network/virtualNetworks', vnet1Name)
      }
      {
        id: resourceId('Microsoft.Network/virtualNetworks', vnet2Name)
      }
    ]
    resolutionVirtualNetworks: [
      {
        id: resourceId('Microsoft.Network/virtualNetworks', vnet1Name)
      }
      {
        id: resourceId('Microsoft.Network/virtualNetworks', vnet2Name)
      }
    ]
  }
}

resource ZoneName_ADFSRecord 'Microsoft.Network/privateDnsZones/a@2018-09-01' = {
  name: '${ZoneName_resource.name}/${ADFSRecord}'
  properties: {
    ttl: 900
    aRecords: [
      {
        ipv4Address: ADFS1PrivateIP
      }
      {
        ipv4Address: ADFS2PrivateIP
      }
    ]
  }
}