@description('DNS Zone Name')
param ZoneName string

@description('WEB EXternal DNS Record')
param WEBRecord string

@description('OCSP EXternal DNS Record')
param OCSPRecord string

@description('OWA EXternal DNS Record')
param OWARecord string

@description('AutoDiscover EXternal DNS Record')
param AutoDiscoverRecord string

@description('Outlook EXternal DNS Record')
param OutlookRecord string

@description('EAS EXternal DNS Record')
param EASRecord string

@description('ADFS EXternal DNS Record')
param ADFSRecord string

@description('SMTP1 EXternal DNS Record')
param SMTP1Record string

@description('SMTP2 EXternal DNS Record')
param SMTP2Record string

@description('WEB EXternal Public IP')
param WEBPublicIP string

@description('OCSP EXternal Public IP')
param OCSPPublicIP string

@description('WAP 1 EXternal Public IP')
param WAP1PublicIP string

@description('WAP 2 EXternal Public IP')
param WAP2PublicIP string

@description('SMTP 1 EXternal Public IP')
param SMTP1PublicIP string

@description('SMTP 2 EXternal Public IP')
param SMTP2PublicIP string

resource ZoneName_resource 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: ZoneName
  location: 'global'
  tags: {}
  properties: {}
}

resource ZoneName_WEBRecord 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${WEBRecord}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: WEBPublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_OCSPRecord 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${OCSPRecord}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: OCSPPublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_OWARecord 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${OWARecord}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: WAP1PublicIP
      }
      {
        ipv4Address: WAP2PublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_AutoDiscoverRecord 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${AutoDiscoverRecord}'

  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: WAP1PublicIP
      }
      {
        ipv4Address: WAP2PublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_OutlookRecord 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${OutlookRecord}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: WAP1PublicIP
      }
      {
        ipv4Address: WAP2PublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_EASRecord 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${EASRecord}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: WAP1PublicIP
      }
      {
        ipv4Address: WAP2PublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_SMTP1Record 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${SMTP1Record}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: SMTP1PublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_SMTP2Record 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${SMTP2Record}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: SMTP2PublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource Microsoft_Network_dnszones_MX_ZoneName 'Microsoft.Network/dnszones/MX@2018-05-01' = {
  name: '${ZoneName_resource.name}/@'
  properties: {
    TTL: 900
    MXRecords: [
      {
        preference: 0
        exchange: '${SMTP1Record}.${ZoneName}'
      }
      {
        preference: 100
        exchange: '${SMTP2Record}.${ZoneName}'
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}

resource ZoneName_ADFSRecord 'Microsoft.Network/dnszones/a@2018-05-01' = {
  name: '${ZoneName_resource.name}/${ADFSRecord}'
  properties: {
    TTL: 900
    ARecords: [
      {
        ipv4Address: WAP1PublicIP
      }
      {
        ipv4Address: WAP2PublicIP
      }
    ]
  }
  dependsOn: [
    ZoneName_resource
  ]
}
