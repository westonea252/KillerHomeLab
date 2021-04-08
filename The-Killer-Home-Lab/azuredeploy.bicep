@allowed([
  'Afghanistan Standard Time'
  'Alaskan Standard Time'
  'Aleutian Standard Time'
  'Altai Standard Time'
  'Arab Standard Time'
  'Arabian Standard Time'
  'Arabic Standard Time'
  'Argentina Standard Time'
  'Astrakhan Standard Time'
  'Atlantic Standard Time'
  'AUS Central Standard Time'
  'Aus Central W. Standard Time'
  'AUS Eastern Standard Time'
  'Azerbaijan Standard Time'
  'Azores Standard Time'
  'Bahia Standard Time'
  'Bangladesh Standard Time'
  'Belarus Standard Time'
  'Bougainville Standard Time'
  'Canada Central Standard Time'
  'Cape Verde Standard Time'
  'Caucasus Standard Time'
  'Cen. Australia Standard Time'
  'Central America Standard Time'
  'Central Asia Standard Time'
  'Central Brazilian Standard Time'
  'Central Europe Standard Time'
  'Central European Standard Time'
  'Central Pacific Standard Time'
  'Central Standard Time (Mexico)'
  'Central Standard Time'
  'Chatham Islands Standard Time'
  'China Standard Time'
  'Cuba Standard Time'
  'Dateline Standard Time'
  'E. Africa Standard Time'
  'E. Australia Standard Time'
  'E. Europe Standard Time'
  'E. South America Standard Time'
  'Easter Island Standard Time'
  'Eastern Standard Time (Mexico)'
  'Eastern Standard Time'
  'Egypt Standard Time'
  'Ekaterinburg Standard Time'
  'Fiji Standard Time'
  'FLE Standard Time'
  'Georgian Standard Time'
  'GMT Standard Time'
  'Greenland Standard Time'
  'Greenwich Standard Time'
  'GTB Standard Time'
  'Haiti Standard Time'
  'Hawaiian Standard Time'
  'India Standard Time'
  'Iran Standard Time'
  'Israel Standard Time'
  'Jordan Standard Time'
  'Kaliningrad Standard Time'
  'Korea Standard Time'
  'Libya Standard Time'
  'Line Islands Standard Time'
  'Lord Howe Standard Time'
  'Magadan Standard Time'
  'Magallanes Standard Time'
  'Marquesas Standard Time'
  'Mauritius Standard Time'
  'Middle East Standard Time'
  'Montevideo Standard Time'
  'Morocco Standard Time'
  'Mountain Standard Time (Mexico)'
  'Mountain Standard Time'
  'Myanmar Standard Time'
  'N. Central Asia Standard Time'
  'Namibia Standard Time'
  'Nepal Standard Time'
  'New Zealand Standard Time'
  'Newfoundland Standard Time'
  'Norfolk Standard Time'
  'North Asia East Standard Time'
  'North Asia Standard Time'
  'North Korea Standard Time'
  'Omsk Standard Time'
  'Pacific SA Standard Time'
  'Pacific Standard Time (Mexico)'
  'Pacific Standard Time'
  'Pakistan Standard Time'
  'Paraguay Standard Time'
  'Qyzylorda Standard Time'
  'Romance Standard Time'
  'Russia Time Zone 10'
  'Russia Time Zone 11'
  'Russia Time Zone 3'
  'Russian Standard Time'
  'SA Eastern Standard Time'
  'SA Pacific Standard Time'
  'SA Western Standard Time'
  'Saint Pierre Standard Time'
  'Sakhalin Standard Time'
  'Samoa Standard Time'
  'Sao Tome Standard Time'
  'Saratov Standard Time'
  'SE Asia Standard Time'
  'Singapore Standard Time'
  'South Africa Standard Time'
  'Sri Lanka Standard Time'
  'Sudan Standard Time'
  'Syria Standard Time'
  'Taipei Standard Time'
  'Tasmania Standard Time'
  'Tocantins Standard Time'
  'Tokyo Standard Time'
  'Tomsk Standard Time'
  'Tonga Standard Time'
  'Transbaikal Standard Time'
  'Turkey Standard Time'
  'Turks And Caicos Standard Time'
  'Ulaanbaatar Standard Time'
  'US Eastern Standard Time'
  'US Mountain Standard Time'
  'UTC'
  'UTC+12'
  'UTC+13'
  'UTC-02'
  'UTC-08'
  'UTC-09'
  'UTC-11'
  'Venezuela Standard Time'
  'Vladivostok Standard Time'
  'Volgograd Standard Time'
  'W. Australia Standard Time'
  'W. Central Africa Standard Time'
  'W. Europe Standard Time'
  'W. Mongolia Standard Time'
  'West Asia Standard Time'
  'West Bank Standard Time'
  'West Pacific Standard Time'
  'Yakutsk Standard Time'
])
@description('Time Zone')
param TimeZone string = 'Eastern Standard Time'

@description('Choose Region (Example: USGovTexas)')
param Location2 string = 'USGovTexas'

@description('Enter an Exchange Organization Name')
param ExchangeOrgName string = '49ers'

@description('Enter Email Address to send completed status')
param ToEmail string = ''

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@allowed([
  'None'
  'Windows_Server'
])
@description('Windows Server OS License Type')
param WindowsServerLicenseType string = 'None'

@allowed([
  'None'
  'Windows_Client'
])
@description('Windows Client OS License Type')
param WindowsClientLicenseType string = 'None'

@description('Enter a valid URL that points to the SQL 2019 or 2017 .ISO')
param SQLSASUrl string = ''

@description('Enter a valid URL that points to the Exchange 2019 CU .ISO')
param Exchange2019ISOUrl string = ''

@description('Download Location of Latest Azure AD Connect')
param AzureADConnectDownloadUrl string = 'https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi'

@description('Environment Naming Convention')
param NamingConvention string = 'khl'

@description('Sub DNS Domain Name Example:  sub1. must include a DOT AT END')
param SubDNSDomain string = ''

@description('Sub DNS Domain Name Example:  DC=sub2,DC=sub1, must include COMMA AT END')
param SubDNSBaseDN string = ''

@description('NetBios Parent Domain Name')
param NetBiosDomain string = 'killerhomelab'

@description('NetBios Parent Domain Name')
param InternalDomain string = 'killerhomelab'

@allowed([
  'com'
  'net'
  'org'
  'edu'
  'gov'
  'mil'
])
@description('Internal Top-Level Domain Name')
param InternalTLD string = 'com'

@description('External DNS Domain')
param ExternalDomain string = 'killerhomelab'

@allowed([
  'com'
  'net'
  'org'
  'edu'
  'gov'
  'mil'
])
@description('External Top-Level Domain Name')
param ExternalTLD string = 'com'

@description('DMZ VNet1 Prefix')
param DMZVNet1ID string = '100.1'

@description('DMZ VNet2 Prefix')
param DMZVNet2ID string = '100.2'

@description('APP VNet1 Prefix')
param APPVNet1ID string = '10.1'

@description('APP VNet1 Prefix')
param APPVNet2ID string = '10.2'

@description('DNS Reverse Lookup Zone1 Prefix')
param ReverseLookup1 string = '1.10'

@description('DNS Reverse Lookup Zone2 Prefix')
param ReverseLookup2 string = '2.10'

@description('Offline Root CA Name')
param RootCAName string = 'Offline Root CA'

@description('Issuing CA Name')
param IssuingCAName string = 'Issuing CA'

@allowed([
  'SHA256'
  'SHA1'
])
@description('Offline Root CA Algorithm')
param RootCAHashAlgorithm string = 'SHA256'

@allowed([
  '4096'
  '2048'
])
@description('Offline Root CA Key Length')
param RootCAKeyLength string = '4096'

@allowed([
  'SHA256'
  'SHA1'
])
@description('Issuing CA Algorithm')
param IssuingCAHashAlgorithm string = 'SHA256'

@allowed([
  '4096'
  '2048'
])
@description('Issuing CA Key Length')
param IssuingCAKeyLength string = '4096'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('WEB OS Version')
param WEBOSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('Domain Controller1 OS Version')
param DC1OSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('Domain Controller2 OS Version')
param DC2OSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('SQL OS Version')
param SQLOSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('Offline Root CA OS Version')
param RCAOSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('Issuing CA OS Version')
param ICAOSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('OCSP OS Version')
param OCSPOSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
])
@description('FS OS Version')
param FSOSVersion string = '2019-Datacenter'

@allowed([
  '2019-Datacenter'
])
@description('EX OS Version')
param EXOSVersion string = '2019-Datacenter'

@description('AD Connect OS Version')
param ADCOSVersion string = '2019-Datacenter'

@description('WAP OS Version')
param WAPOSVersion string = '2019-Datacenter'

@description('ADFS OS Version')
param ADFSOSVersion string = '2019-Datacenter'

@allowed([
  '19h1-pro'
])
@description('Workstation1 OS Version')
param WK1OSVersion string = '19h1-pro'

@allowed([
  '19h1-pro'
])
@description('Workstation2 OS Version')
param WK2OSVersion string = '19h1-pro'

@description('VMSize')
param WEBVMSize string = 'Standard_D2s_v3'

@description('Domain Controller1 VMSize')
param DC1VMSize string = 'Standard_D2s_v3'

@description('Domain Controller2 VMSize')
param DC2VMSize string = 'Standard_D2s_v3'

@description('SQL VMSize')
param SQLVMSize string = 'Standard_D8s_v3'

@description('Offline Root CA VMSize')
param RCAVMSize string = 'Standard_D2s_v3'

@description('Issuing CA VMSize')
param ICAVMSize string = 'Standard_D2s_v3'

@description('OCSP VMSize')
param OCSPVMSize string = 'Standard_D2s_v3'

@description('File Share Witeness Server1 VMSize')
param FS1VMSize string = 'Standard_D2s_v3'

@description('File Share Witeness Server2 VMSize')
param FS2VMSize string = 'Standard_D2s_v3'

@description('Exchange Server1 VMSize')
param EX1VMSize string = 'Standard_D8s_v3'

@description('Exchange Server2 VMSize')
param EX2VMSize string = 'Standard_D8s_v3'

@description('AD Connect VMSize')
param ADCVMSize string = 'Standard_D2s_v3'

@description('ADFS 1 VMSize')
param ADFS1VMSize string = 'Standard_D2s_v3'

@description('ADFS 2 VMSize')
param ADFS2VMSize string = 'Standard_D2s_v3'

@description('WAP 1 VMSize')
param WAP1VMSize string = 'Standard_D2s_v3'

@description('WAP 2 VMSize')
param WAP2VMSize string = 'Standard_D2s_v3'

@description('Workstation1 VMSize')
param WK1VMSize string = 'Standard_D2s_v3'

@description('Workstation2 VMSize')
param WK2VMSize string = 'Standard_D2s_v3'

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param artifactsLocation string = deployment().properties.templateLink.uri

@description('Auto-generated token to access _artifactsLocation. Leave it blank unless you need to provide your own value.')
@secure()
param artifactsLocationSasToken string = ''

var DMZVNet1Name = '${NamingConvention}-DMZ-VNet1'
var DMZVNet1Prefix = '${DMZVNet1ID}.0.0/16'
var DMZVNet1subnet1Name = '${NamingConvention}-DMZ-VNet1-Subnet1'
var DMZVNet1subnet1Prefix = '${DMZVNet1ID}.1.0/24'
var DMZVNet1BastionsubnetPrefix = '${DMZVNet1ID}.253.0/24'
var DMZVNet1FirewallsubnetPrefix = '${DMZVNet1ID}.254.0/24'
var DMZVNet2Name = '${NamingConvention}-DMZ-VNet2'
var DMZVNet2Prefix = '${DMZVNet2ID}.0.0/16'
var DMZVNet2subnet1Name = '${NamingConvention}-DMZ-VNet2-Subnet1'
var DMZVNet2subnet1Prefix = '${DMZVNet2ID}.1.0/24'
var DMZVNet2BastionsubnetPrefix = '${DMZVNet2ID}.253.0/24'
var DMZVNet2FirewallsubnetPrefix = '${DMZVNet2ID}.254.0/24'
var APPVNet1Name = '${NamingConvention}-APP-VNet1'
var APPVNet1Prefix = '${APPVNet1ID}.0.0/16'
var APPVNet1subnet1Name = '${NamingConvention}-APP-VNet1-WEB-Subnet1'
var APPVNet1subnet1Prefix = '${APPVNet1ID}.1.0/24'
var APPVNet1subnet2Name = '${NamingConvention}-APP-VNet1-EX-Subnet1'
var APPVNet1subnet2Prefix = '${APPVNet1ID}.2.0/24'
var APPVNet1subnet3Name = '${NamingConvention}-APP-VNet1-DB-Subnet1'
var APPVNet1subnet3Prefix = '${APPVNet1ID}.3.0/24'
var APPVNet1subnet4Name = '${NamingConvention}-APP-VNet1-AD-Subnet1'
var APPVNet1subnet4Prefix = '${APPVNet1ID}.4.0/24'
var APPVNet1subnet5Name = '${NamingConvention}-APP-VNet1-ID-Subnet1'
var APPVNet1subnet5Prefix = '${APPVNet1ID}.5.0/24'
var APPVNet1subnet6Name = '${NamingConvention}-APP-VNet1-IF-Subnet1'
var APPVNet1subnet6Prefix = '${APPVNet1ID}.6.0/24'
var APPVNet1subnet7Name = '${NamingConvention}-APP-VNet1-WK-Subnet1'
var APPVNet1subnet7Prefix = '${APPVNet1ID}.7.0/24'
var APPVNet2Name = '${NamingConvention}-APP-VNet2'
var APPVNet2Prefix = '${APPVNet2ID}.0.0/16'
var APPVNet2subnet1Name = '${NamingConvention}-APP-VNet2-WEB-Subnet1'
var APPVNet2subnet1Prefix = '${APPVNet2ID}.1.0/24'
var APPVNet2subnet2Name = '${NamingConvention}-APP-VNet2-EX-Subnet1'
var APPVNet2subnet2Prefix = '${APPVNet2ID}.2.0/24'
var APPVNet2subnet3Name = '${NamingConvention}-APP-VNet2-DB-Subnet1'
var APPVNet2subnet3Prefix = '${APPVNet2ID}.3.0/24'
var APPVNet2subnet4Name = '${NamingConvention}-APP-VNet2-AD-Subnet1'
var APPVNet2subnet4Prefix = '${APPVNet2ID}.4.0/24'
var APPVNet2subnet5Name = '${NamingConvention}-APP-VNet2-ID-Subnet1'
var APPVNet2subnet5Prefix = '${APPVNet2ID}.5.0/24'
var APPVNet2subnet6Name = '${NamingConvention}-APP-VNet2-IF-Subnet1'
var APPVNet2subnet6Prefix = '${APPVNet2ID}.6.0/24'
var APPVNet2subnet7Name = '${NamingConvention}-APP-VNet2-WK-Subnet1'
var APPVNet2subnet7Prefix = '${APPVNet2ID}.7.0/24'
var FirewallName1 = '${NamingConvention}-Firewall-01'
var FirewallName2 = '${NamingConvention}-Firewall-02'
var NSG1Name = '${NamingConvention}-nsg01'
var NSG2Name = '${NamingConvention}-nsg02'
var NSG3Name = '${NamingConvention}-nsg03'
var NSG4Name = '${NamingConvention}-nsg04'
var NSG5Name = '${NamingConvention}-nsg05'
var NSG6Name = '${NamingConvention}-nsg06'
var NSG7Name = '${NamingConvention}-nsg07'
var RouteTableName1 = '${NamingConvention}-APP-RT1'
var RouteTableName2 = '${NamingConvention}-APP-RT2'
var fw1IP = '${DMZVNet1ID}.254.${fw1lastoctet}'
var fw1lastoctet = '4'
var fw2IP = '${DMZVNet2ID}.254.${fw2lastoctet}'
var fw2lastoctet = '4'
var webname = '${NamingConvention}-web-01'
var webIP = '${APPVNet1ID}.1.${weblastoctet}'
var weblastoctet = '100'
var dc1name = '${NamingConvention}-dc-01'
var dc1IP = '${APPVNet1ID}.4.${dc1lastoctet}'
var dc1lastoctet = '100'
var dc2name = '${NamingConvention}-dc-02'
var dc2IP = '${APPVNet2ID}.4.${dc2lastoctet}'
var dc2lastoctet = '100'
var DCDataDisk1Name = 'NTDS'
var ReverseLookup1_var = '4.${ReverseLookup1}'
var ReverseLookup2_var = '4.${ReverseLookup2}'
var sqlname = '${NamingConvention}-sql-01'
var sqlIP = '${APPVNet1ID}.3.${sqllastoctet}'
var sqllastoctet = '100'
var rcaname = '${NamingConvention}-rca-01'
var rcaIP = '${APPVNet1ID}.6.${rcalastoctet}'
var rcalastoctet = '100'
var icaname = '${NamingConvention}-ica-01'
var icaIP = '${APPVNet1ID}.6.${icalastoctet}'
var icalastoctet = '101'
var ocspname = '${NamingConvention}-ocsp-01'
var ocspIP = '${APPVNet1ID}.6.${ocsplastoctet}'
var ocsplastoctet = '102'
var CATemplateScriptUrl = 'https://elliottf.blob.core.windows.net/github/Scripts/Create_CA_Templates.ps1'
var fs1name = '${NamingConvention}-fs-01'
var FS1IP = '${APPVNet1ID}.2.${fs1lastoctet}'
var fs1lastoctet = '100'
var fs2name = '${NamingConvention}-fs-02'
var FS2IP = '${APPVNet2ID}.2.${fs2lastoctet}'
var fs2lastoctet = '100'
var ex1name = '${NamingConvention}-ex-01'
var EX1IP = '${APPVNet1ID}.2.${ex1lastoctet}'
var ex1lastoctet = '101'
var ex2name = '${NamingConvention}-ex-02'
var EX2IP = '${APPVNet2ID}.2.${ex2lastoctet}'
var ex2lastoctet = '101'
var DB1Name = '${NamingConvention}-19-db01'
var DB2Name = '${NamingConvention}-19-db02'
var DAG19Name = '${NamingConvention}-19-dag01'
var adcname = '${NamingConvention}-adc-01'
var adcIP = '${APPVNet1ID}.5.${adclastoctet}'
var adclastoctet = '100'
var adfs1name = '${NamingConvention}-adfs-01'
var adfs1IP = '${APPVNet1ID}.5.${adfs1lastoctet}'
var adfs1lastoctet = '101'
var adfs2name = '${NamingConvention}-adfs-02'
var adfs2IP = '${APPVNet2ID}.5.${adfs2lastoctet}'
var adfs2lastoctet = '101'
var wap1name = '${NamingConvention}-wap-01'
var wap1IP = '${DMZVNet1ID}.1.${wap1lastoctet}'
var wap1lastoctet = '101'
var wap2name = '${NamingConvention}-wap-02'
var wap2IP = '${DMZVNet2ID}.1.${wap2lastoctet}'
var wap2lastoctet = '102'
var wk1name = '${NamingConvention}-wk-01'
var wk1IP = '${APPVNet1ID}.7.${wk1lastoctet}'
var wk1lastoctet = '100'
var wk2name = '${NamingConvention}-wk-02'
var wk2IP = '${APPVNet2ID}.7.${wk2lastoctet}'
var wk2lastoctet = '100'
var InternaldomainName = '${SubDNSDomain}${InternalDomain}.${InternalTLD}'
var ExternaldomainName = '${ExternalDomain}.${ExternalTLD}'
var BaseDN = '${SubDNSBaseDN}DC=${InternalDomain},DC=${InternalTLD}'
var SRVOUPath = 'OU=Servers,${BaseDN}'
var WKOUPath = 'OU=Windows 10,OU=Workstations,${BaseDN}'
var FromEmail = '${adminUsername}@${InternaldomainName}'

module DMZVNet1 'nestedtemplates/dmzvnet.bicep' = {
  name: 'DMZVNet1'
  params: {
    vnetName: DMZVNet1Name
    vnetprefix: DMZVNet1Prefix
    subnet1Name: DMZVNet1subnet1Name
    subnet1Prefix: DMZVNet1subnet1Prefix
    BastionsubnetPrefix: DMZVNet1BastionsubnetPrefix
    FirewallsubnetPrefix: DMZVNet1FirewallsubnetPrefix
    location: resourceGroup().location
  }
}

module DMZVNet2 'nestedtemplates/dmzvnet.bicep' = {
  name: 'DMZVNet2'
  params: {
    vnetName: DMZVNet2Name
    vnetprefix: DMZVNet2Prefix
    subnet1Name: DMZVNet2subnet1Name
    subnet1Prefix: DMZVNet2subnet1Prefix
    BastionsubnetPrefix: DMZVNet2BastionsubnetPrefix
    FirewallsubnetPrefix: DMZVNet2FirewallsubnetPrefix
    location: Location2
  }
}

module APPVNet1 'nestedtemplates/appvnet.bicep' = {
  name: 'APPVNet1'
  params: {
    vnetName: APPVNet1Name
    vnetprefix: APPVNet1Prefix
    subnet1Name: APPVNet1subnet1Name
    subnet1Prefix: APPVNet1subnet1Prefix
    subnet2Name: APPVNet1subnet2Name
    subnet2Prefix: APPVNet1subnet2Prefix
    subnet3Name: APPVNet1subnet3Name
    subnet3Prefix: APPVNet1subnet3Prefix
    subnet4Name: APPVNet1subnet4Name
    subnet4Prefix: APPVNet1subnet4Prefix
    subnet5Name: APPVNet1subnet5Name
    subnet5Prefix: APPVNet1subnet5Prefix
    subnet6Name: APPVNet1subnet6Name
    subnet6Prefix: APPVNet1subnet6Prefix
    subnet7Name: APPVNet1subnet7Name
    subnet7Prefix: APPVNet1subnet7Prefix
    location: resourceGroup().location
  }
}

module APPVNet2 'nestedtemplates/appvnet.bicep' = {
  name: 'APPVNet2'
  params: {
    vnetName: APPVNet2Name
    vnetprefix: APPVNet2Prefix
    subnet1Name: APPVNet2subnet1Name
    subnet1Prefix: APPVNet2subnet1Prefix
    subnet2Name: APPVNet2subnet2Name
    subnet2Prefix: APPVNet2subnet2Prefix
    subnet3Name: APPVNet2subnet3Name
    subnet3Prefix: APPVNet2subnet3Prefix
    subnet4Name: APPVNet2subnet4Name
    subnet4Prefix: APPVNet2subnet4Prefix
    subnet5Name: APPVNet2subnet5Name
    subnet5Prefix: APPVNet2subnet5Prefix
    subnet6Name: APPVNet2subnet6Name
    subnet6Prefix: APPVNet2subnet6Prefix
    subnet7Name: APPVNet2subnet7Name
    subnet7Prefix: APPVNet2subnet7Prefix
    location: Location2
  }
}

module DMZVNet1ToDMZVNet2Peering 'nestedtemplates/peering.bicep' = {
  name: 'DMZVNet1ToDMZVNet2Peering'
  params: {
    SourceVNetName: DMZVNet1Name
    TargetVNetName: DMZVNet2Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: resourceGroup().location
  }
  dependsOn: [
    DMZVNet1
    DMZVNet2
  ]
}

module DMZVNet2ToDMZVNet1Peering 'nestedtemplates/peering.bicep' = {
  name: 'DMZVNet2ToDMZVNet1Peering'
  params: {
    SourceVNetName: DMZVNet2Name
    TargetVNetName: DMZVNet1Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: Location2
  }
  dependsOn: [
    DMZVNet1
    DMZVNet2
  ]
}

module APPVNet1ToDMZVNet1Peering 'nestedtemplates/peering.bicep'  = {
  name: 'APPVNet1ToDMZVNet1Peering'
  params: {
    SourceVNetName: APPVNet1Name
    TargetVNetName: DMZVNet1Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: resourceGroup().location
  }
  dependsOn: [
    DMZVNet1
    APPVNet1
  ]
}

module APPVNet1ToDMZVNet2Peering 'nestedtemplates/peering.bicep' = {
  name: 'APPVNet1ToDMZVNet2Peering'
  params: {
    SourceVNetName: APPVNet1Name
    TargetVNetName: DMZVNet2Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: resourceGroup().location
  }
  dependsOn: [
    DMZVNet2
    APPVNet1
  ]
}

module APPVNet2ToDMZVNet1Peering 'nestedtemplates/peering.bicep' = {
  name: 'APPVNet2ToDMZVNet1Peering'
  params: {
    SourceVNetName: APPVNet2Name
    TargetVNetName: DMZVNet1Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: Location2
  }
  dependsOn: [
    DMZVNet2
    APPVNet2
  ]
}

module APPVNet2ToDMZVNet2Peering 'nestedtemplates/peering.bicep' = {
  name: 'APPVNet2ToDMZVNet2Peering'
  params: {
    SourceVNetName: APPVNet2Name
    TargetVNetName: DMZVNet2Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: Location2
  }
  dependsOn: [
    DMZVNet2
    APPVNet2
  ]
}

module DMZVNet1ToAPPVNet1Peering 'nestedtemplates/peering.bicep' = {
  name: 'DMZVNet1ToAPPVNet1Peering'
  params: {
    SourceVNetName: DMZVNet1Name
    TargetVNetName: APPVNet1Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: resourceGroup().location
  }
  dependsOn: [
    DMZVNet1
    APPVNet1
  ]
}

module DMZVNet1ToAPPVNet2Peering 'nestedtemplates/peering.bicep' = {
  name: 'DMZVNet1ToAPPVNet2Peering'
  params: {
    SourceVNetName: DMZVNet1Name
    TargetVNetName: APPVNet2Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: resourceGroup().location
  }
  dependsOn: [
    DMZVNet1
    APPVNet2
  ]
}

module DMZVNet2ToAPPVNet1Peering 'nestedtemplates/peering.bicep' = {
  name: 'DMZVNet2ToAPPVNet1Peering'
  params: {
    SourceVNetName: DMZVNet2Name
    TargetVNetName: APPVNet1Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: Location2
  }
  dependsOn: [
    DMZVNet2
    APPVNet1
  ]
}

module DMZVNet2ToAPPVNet2Peering 'nestedtemplates/peering.bicep' = {
  name: 'DMZVNet2ToAPPVNet2Peering'
  params: {
    SourceVNetName: DMZVNet2Name
    TargetVNetName: APPVNet2Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: Location2
  }
  dependsOn: [
    DMZVNet2
    APPVNet2
  ]
}

module APPVNet1ToAPPVNet2Peering 'nestedtemplates/peering.bicep' = {
  name: 'APPVNet1ToAPPVNet2Peering'
  params: {
    SourceVNetName: APPVNet1Name
    TargetVNetName: APPVNet2Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: resourceGroup().location
  }
  dependsOn: [
    APPVNet1
    APPVNet2
  ]
}

module APPVNet2ToAPPVNet1Peering 'nestedtemplates/peering.bicep' = {
  name: 'APPVNet2ToAPPVNet1Peering'
  params: {
    SourceVNetName: APPVNet2Name
    TargetVNetName: APPVNet1Name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    location: Location2
  }
  dependsOn: [
    APPVNet2
    APPVNet1
  ]
}

module BastionHost1 'nestedtemplates/bastionhost.bicep' = {
  name: 'BastionHost1'
  params: {
    publicIPAddressName: '${DMZVNet1Name}-Bastion-pip'
    AllocationMethod: 'Static'
    vnetName: DMZVNet1Name
    subnetName: 'AzureBastionSubnet'
    location: resourceGroup().location
  }
  dependsOn: [
    DMZVNet1
  ]
}

module DeployAzureFirewall1 'nestedtemplates/AzureFirewall.bicep' = {
  name: 'DeployAzureFirewall1'
  params: {
    FirewallName: FirewallName1
    vnetName: DMZVNet1Name
    subnetName: 'AzureFirewallSubnet'
    APPVNet1Prefix: APPVNet1Prefix
    APPVNet2Prefix: APPVNet2Prefix
    DMZVNet1Prefix: DMZVNet1Prefix
    DMZVNet2Prefix: DMZVNet2Prefix
    webIP: webIP
    OCSPIP: ocspIP
    WAPIP: wap1IP
    SMTPIP: EX1IP
    location: resourceGroup().location
  }
  dependsOn: [
    DMZVNet1
  ]
}

module DeployAzureFirewall2 'nestedtemplates/AzureFirewall.bicep' = {
  name: 'DeployAzureFirewall2'
  params: {
    FirewallName: FirewallName2
    vnetName: DMZVNet2Name
    subnetName: 'AzureFirewallSubnet'
    APPVNet1Prefix: APPVNet1Prefix
    APPVNet2Prefix: APPVNet2Prefix
    DMZVNet1Prefix: DMZVNet1Prefix
    DMZVNet2Prefix: DMZVNet2Prefix
    webIP: webIP
    OCSPIP: ocspIP
    WAPIP: wap2IP
    SMTPIP: EX2IP
    location: Location2
  }
  dependsOn: [
    DMZVNet2
  ]
}

module DeployAPP1RouteTable 'nestedtemplates/RouteTable.bicep' = {
  name: 'DeployAPP1RouteTable'
  params: {
    FirewallIP: fw1IP
    RouteTableName: RouteTableName1
    location: resourceGroup().location
  }
  dependsOn: [
    APPVNet1
  ]
}

module DeployAPP2RouteTable 'nestedtemplates/RouteTable.bicep' = {
  name: 'DeployAPP2RouteTable'
  params: {
    FirewallIP: fw2IP
    RouteTableName: RouteTableName2
    location: Location2
  }
  dependsOn: [
    APPVNet2
  ]
}

module UpdateAPPVNet1SubnetsRouteTables 'nestedtemplates/updateappvnetroutetable.bicep' = {
  name: 'UpdateAPPVNet1SubnetsRouteTables'
  params: {
    vnetName: APPVNet1Name
    vnetprefix: APPVNet1Prefix
    subnet1Name: APPVNet1subnet1Name
    subnet1Prefix: APPVNet1subnet1Prefix
    subnet2Name: APPVNet1subnet2Name
    subnet2Prefix: APPVNet1subnet2Prefix
    subnet3Name: APPVNet1subnet3Name
    subnet3Prefix: APPVNet1subnet3Prefix
    subnet4Name: APPVNet1subnet4Name
    subnet4Prefix: APPVNet1subnet4Prefix
    subnet5Name: APPVNet1subnet5Name
    subnet5Prefix: APPVNet1subnet5Prefix
    subnet6Name: APPVNet1subnet6Name
    subnet6Prefix: APPVNet1subnet6Prefix
    subnet7Name: APPVNet1subnet7Name
    subnet7Prefix: APPVNet1subnet7Prefix
    RouteTableName: RouteTableName1
    location: resourceGroup().location
  }
  dependsOn: [
    DeployAPP1RouteTable
  ]
}

module UpdateAPPVNet2SubnetsRouteTables 'nestedtemplates/updateappvnetroutetable.bicep' = {
  name: 'UpdateAPPVNet2SubnetsRouteTables'
  params: {
    vnetName: APPVNet2Name
    vnetprefix: APPVNet2Prefix
    subnet1Name: APPVNet2subnet1Name
    subnet1Prefix: APPVNet2subnet1Prefix
    subnet2Name: APPVNet2subnet2Name
    subnet2Prefix: APPVNet2subnet2Prefix
    subnet3Name: APPVNet2subnet3Name
    subnet3Prefix: APPVNet2subnet3Prefix
    subnet4Name: APPVNet2subnet4Name
    subnet4Prefix: APPVNet2subnet4Prefix
    subnet5Name: APPVNet2subnet5Name
    subnet5Prefix: APPVNet2subnet5Prefix
    subnet6Name: APPVNet2subnet6Name
    subnet6Prefix: APPVNet2subnet6Prefix
    subnet7Name: APPVNet2subnet7Name
    subnet7Prefix: APPVNet2subnet7Prefix
    RouteTableName: RouteTableName2
    location: Location2
  }
  dependsOn: [
    DeployAPP2RouteTable
  ]
}

module deployWEBVM 'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployWEBVM'
  params: {
    computerName: webname
    computerIP: webIP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: WEBOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: WEBVMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet1Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    APPVNet1
  ]
}

module InstallIIS 'nestedtemplates/iis.bicep' = {
  name: 'InstallIIS'
  params: {
    computerName: webname
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DeployAzureFirewall1
    deployWEBVM
  ]
}

module deployDC1VM 'nestedtemplates/1nic-2disk-vm.bicep' = {
  name: 'deployDC1VM'
  params: {
    computerName: dc1name
    computerIP: dc1IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: DC1OSVersion
    licenseType: WindowsServerLicenseType
    DataDisk1Name: DCDataDisk1Name
    VMSize: DC1VMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet4Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    APPVNet1
  ]
}

module promotedc1 'nestedtemplates/firstdc.bicep' = {
  name: 'promotedc1'
  params: {
    computerName: dc1name
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    domainName: InternaldomainName
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    deployDC1VM
  ]
}

module UpdateAPPVNet1DNS_1 'nestedtemplates/updateappvnetdns.bicep' = {
  name: 'UpdateAPPVNet1DNS-1'
  params: {
    vnetName: APPVNet1Name
    vnetprefix: APPVNet1Prefix
    subnet1Name: APPVNet1subnet1Name
    subnet1Prefix: APPVNet1subnet1Prefix
    subnet2Name: APPVNet1subnet2Name
    subnet2Prefix: APPVNet1subnet2Prefix
    subnet3Name: APPVNet1subnet3Name
    subnet3Prefix: APPVNet1subnet3Prefix
    subnet4Name: APPVNet1subnet4Name
    subnet4Prefix: APPVNet1subnet4Prefix
    subnet5Name: APPVNet1subnet5Name
    subnet5Prefix: APPVNet1subnet5Prefix
    subnet6Name: APPVNet1subnet6Name
    subnet6Prefix: APPVNet1subnet6Prefix
    subnet7Name: APPVNet1subnet7Name
    subnet7Prefix: APPVNet1subnet7Prefix
    RouteTableName: RouteTableName1
    DNSServerIP: [
      dc1IP
    ]
    location: resourceGroup().location
  }
  dependsOn: [
    promotedc1
  ]
}

module UpdateAPPVNet2DNS_1 'nestedtemplates/updateappvnetdns.bicep' = {
  name: 'UpdateAPPVNet2DNS-1'
  params: {
    vnetName: APPVNet2Name
    vnetprefix: APPVNet2Prefix
    subnet1Name: APPVNet2subnet1Name
    subnet1Prefix: APPVNet2subnet1Prefix
    subnet2Name: APPVNet2subnet2Name
    subnet2Prefix: APPVNet2subnet2Prefix
    subnet3Name: APPVNet2subnet3Name
    subnet3Prefix: APPVNet2subnet3Prefix
    subnet4Name: APPVNet2subnet4Name
    subnet4Prefix: APPVNet2subnet4Prefix
    subnet5Name: APPVNet2subnet5Name
    subnet5Prefix: APPVNet2subnet5Prefix
    subnet6Name: APPVNet2subnet6Name
    subnet6Prefix: APPVNet2subnet6Prefix
    subnet7Name: APPVNet2subnet7Name
    subnet7Prefix: APPVNet2subnet7Prefix
    RouteTableName: RouteTableName2
    DNSServerIP: [
      dc1IP
    ]
    location: Location2
  }
  dependsOn: [
    promotedc1
  ]
}

module restartdc1 'nestedtemplates/restartvm.bicep' = {
  name: 'restartdc1'
  params: {
    computerName: dc1name
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    UpdateAPPVNet1DNS_1
    UpdateAPPVNet2DNS_1
  ]
}

module configdns 'nestedtemplates/configdns.bicep' = {
  name: 'configdns'
  params: {
    computerName: dc1name
    DC2Name: dc2name    
    NetBiosDomain: NetBiosDomain
    InternaldomainName: InternaldomainName
    ExternaldomainName: ExternaldomainName
    ReverseLookup1: ReverseLookup1_var
    ReverseLookup2: ReverseLookup2_var
    dc1lastoctet: dc1lastoctet
    dc2lastoctet: dc2lastoctet
    ex1IP: EX1IP
    ex2IP: EX2IP
    icaIP: icaIP
    ocspIP: ocspIP
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    restartdc1
  ]
}

module createous 'nestedtemplates/createous.bicep' = {
  name: 'createous'
  params: {
    computerName: dc1name
    BaseDN: BaseDN
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    configdns
  ]
}

module createsites 'nestedtemplates/createsites.bicep' = {
  name: 'createsites'
  params: {
    computerName: dc1name
    NamingConvention: NamingConvention
    BaseDN: BaseDN
    Site1Prefix: APPVNet1Prefix
    Site2Prefix: APPVNet2Prefix
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    createous
  ]
}

module deployDC2VM 'nestedtemplates/1nic-2disk-vm.bicep' = {
  name: 'deployDC2VM'
  params: {
    computerName: dc2name
    computerIP: dc2IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: DC2OSVersion
    licenseType: WindowsServerLicenseType
    DataDisk1Name: DCDataDisk1Name
    VMSize: DC2VMSize
    vnetName: APPVNet2Name
    subnetName: APPVNet2subnet4Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    createsites
  ]
}

module promotedc2 'nestedtemplates/otherdc.bicep' = {
  name: 'promotedc2'
  params: {
    computerName: dc2name
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    domainName: InternaldomainName
    DnsServerIP: dc1IP
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: Location2
  }
  dependsOn: [
    deployDC2VM
  ]
}

module UpdateAPPVNet2DNS_2 'nestedtemplates/updateappvnetdns.bicep' = {
  name: 'UpdateAPPVNet2DNS-2'
  params: {
    vnetName: APPVNet2Name
    vnetprefix: APPVNet2Prefix
    subnet1Name: APPVNet2subnet1Name
    subnet1Prefix: APPVNet2subnet1Prefix
    subnet2Name: APPVNet2subnet2Name
    subnet2Prefix: APPVNet2subnet2Prefix
    subnet3Name: APPVNet2subnet3Name
    subnet3Prefix: APPVNet2subnet3Prefix
    subnet4Name: APPVNet2subnet4Name
    subnet4Prefix: APPVNet2subnet4Prefix
    subnet5Name: APPVNet2subnet5Name
    subnet5Prefix: APPVNet2subnet5Prefix
    subnet6Name: APPVNet2subnet6Name
    subnet6Prefix: APPVNet2subnet6Prefix
    subnet7Name: APPVNet2subnet7Name
    subnet7Prefix: APPVNet2subnet7Prefix
    RouteTableName: RouteTableName2
    DNSServerIP: [
      dc2IP
    ]
    location: Location2
  }
  dependsOn: [
    promotedc2
  ]
}

module restartdc2 'nestedtemplates/restartvm.bicep' = {
  name: 'restartdc2'
  params: {
    computerName: dc2name
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: Location2
  }
  dependsOn: [
    UpdateAPPVNet2DNS_2
  ]
}

module deploySQLVM  'nestedtemplates/1nic-3disk-vm.bicep' = {
  name: 'deploySQLVM'
  params: {
    computerName: sqlname
    computerIP: sqlIP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: SQLOSVersion
    licenseType: WindowsServerLicenseType
    DataDisk1Name: 'SQLDatabases'
    DataDisk2Name: 'SQLLogs'
    VMSize: SQLVMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet3Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createsites
  ]
}

module DomainJoinSQL  'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinSQL'
  params: {
    computerName: sqlname
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    deploySQLVM
  ]
}

module InstallSQL  'nestedtemplates/sql.bicep' = {
  name: 'InstallSQL'
  params: {
    computerName: sqlname
    TimeZone: TimeZone
    SQLSASUrl: SQLSASUrl
    NetBiosDomain: NetBiosDomain
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    deploySQLVM
    DomainJoinSQL
  ]
}

module DeployRootCA 'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'DeployRootCA'
  params: {
    computerName: rcaname
    computerIP: rcaIP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: RCAOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: RCAVMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet6Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
  ]
}

module ConfigureRootCA  'nestedtemplates/rootca.bicep' = {
  name: 'ConfigureRootCA'
  params: {
    computerName: rcaname
    TimeZone: TimeZone
    RootCAName: RootCAName
    RootCAHashAlgorithm: RootCAHashAlgorithm
    RootCAKeyLength: RootCAKeyLength
    domainName: ExternaldomainName
    BaseDN: BaseDN
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DeployRootCA
  ]
}

module DeployIssuingCA  'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'DeployIssuingCA'
  params: {
    computerName: icaname
    computerIP: icaIP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: ICAOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: ICAVMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet6Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    ConfigureRootCA
  ]
}

module DomainJoinIssuingCA  'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinIssuingCA'
  params: {
    computerName: icaname
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    DeployIssuingCA
  ]
}

module ConfigureIssueCA  'nestedtemplates/issueca.bicep' = {
  name: 'ConfigureIssueCA'
  params: {
    computerName: icaname
    TimeZone: TimeZone
    NamingConvention: NamingConvention
    NetBiosDomain: NetBiosDomain
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    RootCAIP: rcaIP
    IssuingCAHashAlgorithm: IssuingCAHashAlgorithm
    IssuingCAKeyLength: IssuingCAKeyLength
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinIssuingCA
  ]
}

module GrantCARequest  'nestedtemplates/grantca.bicep' = {
  name: 'GrantCARequest'
  params: {
    computerName: rcaname
    NamingConvention: NamingConvention
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    ConfigureIssueCA
  ]
}

module FinalizeCA  'nestedtemplates/finalizeca.bicep' = {
  name: 'FinalizeCA'
  params: {
    computerName: icaname
    RootCAIP: rcaIP
    NetBiosDomain: NetBiosDomain
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    domainName: ExternaldomainName
    CATemplateScriptUrl: CATemplateScriptUrl
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    GrantCARequest
  ]
}

module DeployOCSP  'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'DeployOCSP'
  params: {
    computerName: ocspname
    computerIP: ocspIP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: OCSPOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: OCSPVMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet6Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    FinalizeCA
  ]
}

module DomainJoinOCSP  'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinOCSP'
  params: {
    computerName: ocspname
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    DeployOCSP
  ]
}

module ConfigureOCSP  'nestedtemplates/ocsp.bicep' = {
  name: 'ConfigureOCSP'
  params: {
    computerName: ocspname
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    InternaldomainName: InternaldomainName
    ExternaldomainName: ExternaldomainName
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinOCSP
  ]
}

module ReplicateAD  'nestedtemplates/replicatead.bicep' = {
  name: 'ReplicateAD'
  params: {
    computerName: dc1name
    NetBiosDomain: NetBiosDomain
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    ConfigureOCSP
  ]
}

module deployfs1  'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployfs1'
  params: {
    computerName: fs1name
    computerIP: FS1IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: FSOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: FS1VMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet2Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
  ]
}

module DomainJoinFS1  'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinFS1'
  params: {
    computerName: fs1name
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    deployfs1
  ]
}

module deployfs2  'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployfs2'
  params: {
    computerName: fs2name
    computerIP: FS2IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: FSOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: FS2VMSize
    vnetName: APPVNet2Name
    subnetName: APPVNet2subnet2Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    restartdc2
  ]
}

module DomainJoinFS2  'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinFS2'
  params: {
    computerName: fs2name
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    deployfs2
  ]
}

module deployex1  'nestedtemplates/1nic-3disk-vm.bicep' = {
  name: 'deployex1'
  params: {
    computerName: ex1name
    computerIP: EX1IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: EXOSVersion
    licenseType: WindowsServerLicenseType
    DataDisk1Name: 'Exchange'
    DataDisk2Name: 'Software'
    VMSize: EX1VMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet2Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
  ]
}

module DomainJoinEX1  'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinEX1'
  params: {
    computerName: ex1name
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    deployex1
  ]
}

module prepareexchange19s1  'nestedtemplates/prepareexchange19.bicep' = {
  name: 'prepareexchange19s1'
  params: {
    computerName: ex1name
    TimeZone: TimeZone
    ExchangeSASUrl: Exchange2019ISOUrl
    NetBiosDomain: NetBiosDomain
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinEX1
  ]
}

module restartex1_1  'nestedtemplates/restartvm.bicep' = {
  name: 'restartex1-1'
  params: {
    computerName: ex1name
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    prepareexchange19s1
  ]
}

module deployex2  'nestedtemplates/1nic-3disk-vm.bicep' = {
  name: 'deployex2'
  params: {
    computerName: ex2name
    computerIP: EX2IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: EXOSVersion
    licenseType: WindowsServerLicenseType
    DataDisk1Name: 'Exchange'
    DataDisk2Name: 'Software'
    VMSize: EX2VMSize
    vnetName: APPVNet2Name
    subnetName: APPVNet2subnet2Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    restartdc2
  ]
}

module DomainJoinEX2  'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinEX2'
  params: {
    computerName: ex2name
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    deployex2
  ]
}

module prepareexchange19s2  'nestedtemplates/prepareexchange19.bicep' = {
  name: 'prepareexchange19s2'
  params: {
    computerName: ex2name
    TimeZone: TimeZone
    ExchangeSASUrl: Exchange2019ISOUrl
    NetBiosDomain: NetBiosDomain
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinEX2
  ]
}

module restartex2_1  'nestedtemplates/restartvm.bicep' = {
  name: 'restartex2-1'
  params: {
    computerName: ex2name
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: Location2
  }
  dependsOn: [
    prepareexchange19s2
  ]
}

module prepareadexchange19 'nestedtemplates/prepareadexchange19.bicep' = {
  name: 'prepareadexchange19'
  params: {
    computerName: ex1name
    ExchangeOrgname: ExchangeOrgName
    NetBiosDomain: NetBiosDomain
    DC1Name: dc1name
    DC2Name: dc2name
    BaseDN: BaseDN
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    ReplicateAD
    restartex1_1
  ]
}

module grantextrustedsub1 'nestedtemplates/grantets.bicep' = {
  name: 'grantextrustedsub1'
  params: {
    computerName: fs1name
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinFS1
    prepareadexchange19
  ]
}

module grantextrustedsub2 'nestedtemplates/grantets.bicep' = {
  name: 'grantextrustedsub2'
  params: {
    computerName: fs2name
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    location: Location2
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinFS2
    prepareadexchange19
  ]
}

module installexchange1 'nestedtemplates/exchange19.bicep' = {
  name: 'installexchange1'
  params: {
    computerName: ex1name
    NetBiosDomain: NetBiosDomain
    DBName: DB1Name
    SetupDC: dc1name
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinEX1
    prepareexchange19s1
    prepareadexchange19
  ]
}

module configexchange1 'nestedtemplates/configexchange19.bicep' = {
  name: 'configexchange1'
  params: {
    computerName: ex1name
    InternaldomainName: InternaldomainName
    ExternaldomainName: ExternaldomainName
    NetBiosDomain: NetBiosDomain
    BaseDN: BaseDN
    Site1DC: dc1name
    Site2DC: dc2name
    ConfigDC: dc1name
    CAServerIP: icaIP
    Site: 'Site1'
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    restartdc1
    installexchange1
  ]
}

module installexchange2 'nestedtemplates/exchange19.bicep' = {
  name: 'installexchange2'
  params: {
    computerName: ex2name
    NetBiosDomain: NetBiosDomain
    SetupDC: dc2name
    location: Location2
    DBName: DB2Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinEX2
    prepareexchange19s2
    prepareadexchange19
    configexchange1
  ]
}

module configexchange2 'nestedtemplates/configexchange19.bicep' = {
  name: 'configexchange2'
  params: {
    computerName: ex2name
    InternaldomainName: InternaldomainName
    ExternaldomainName: ExternaldomainName
    NetBiosDomain: NetBiosDomain
    BaseDN: BaseDN    
    Site1DC: dc1name
    Site2DC: dc2name
    ConfigDC: dc2name
    CAServerIP: icaIP
    Site: 'Site2'
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    restartdc2
    installexchange2
  ]
}

module restartex1_2 'nestedtemplates/restartvm.bicep' = {
  name: 'restartex1-2'
  params: {
    computerName: ex1name
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    configexchange2
  ]
}

module restartex2_2 'nestedtemplates/restartvm.bicep' = {
  name: 'restartex2-2'
  params: {
    computerName: ex2name
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
    location: Location2
  }
  dependsOn: [
    configexchange2
  ]
}

module createFSGMSA 'nestedtemplates/createfsgmsa.bicep' = {
  name: 'createFSGMSA'
  params: {
    computerName: dc1name
    NetBiosDomain: NetBiosDomain
    domainName: ExternaldomainName
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    createsites
  ]
}

module deployADCVM 'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployADCVM'
  params: {
    computerName: adcname
    computerIP: adcIP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: ADCOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: ADCVMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet5Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
  ]
}

module DomainJoinADC 'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinADC'
  params: {
    computerName: adcname
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    deployADCVM
  ]
}

module downloadaaddc 'nestedtemplates/downloadaaddc.bicep' = {
  name: 'downloadaaddc'
  params: {
    computerName: adcname
    TimeZone: TimeZone
    AzureADConnectDownloadUrl: AzureADConnectDownloadUrl
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinADC
  ]
}

module deployADFS1VM 'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployADFS1VM'
  params: {
    computerName: adfs1name
    computerIP: adfs1IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: ADFSOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: ADFS1VMSize
    vnetName: APPVNet1Name
    subnetName: APPVNet1subnet5Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
    createFSGMSA
  ]
}

module DomainJoinADFS1 'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinADFS1'
  params: {
    computerName: adfs1name
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    deployADFS1VM
  ]
}

module configurefirstadfs 'nestedtemplates/firstadfswithsql.bicep' = {
  name: 'configurefirstadfs'
  params: {
    computerName: adfs1name
    TimeZone: TimeZone
    SQLHost: sqlname
    ExternaldomainName: ExternaldomainName
    NetBiosDomain: NetBiosDomain
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    ReplicateAD
    createFSGMSA
    DomainJoinADFS1
  ]
}

module deployADFS2VM 'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployADFS2VM'
  params: {
    computerName: adfs2name
    computerIP: adfs2IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: ADFSOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: ADFS2VMSize
    vnetName: APPVNet2Name
    subnetName: APPVNet2subnet5Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    createous
    createFSGMSA
  ]
}

module DomainJoinADFS2 'nestedtemplates/domainjoin.bicep' = {
  name: 'DomainJoinADFS2'
  params: {
    computerName: adfs2name
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    deployADFS2VM
  ]
}

module configureotheradfs 'nestedtemplates/otheradfswithsql.bicep' = {
  name: 'configureotheradfs'
  params: {
    computerName: adfs2name
    TimeZone: TimeZone
    SQLHost: sqlname
    ExternaldomainName: ExternaldomainName
    NetBiosDomain: NetBiosDomain
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    adminUsername: adminUsername
    PrimaryADFSServerIP: adfs1IP
    adminPassword: adminPassword
    location: Location2
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    createFSGMSA
    configurefirstadfs
    DomainJoinADFS2
  ]
}

module deployWAP1VM 'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployWAP1VM'
  params: {
    computerName: wap1name
    computerIP: wap1IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: WAPOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: WAP1VMSize
    vnetName: DMZVNet1Name
    subnetName: DMZVNet1subnet1Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    configureotheradfs
  ]
}

module configurefirstwap 'nestedtemplates/wap.bicep' = {
  name: 'configurefirstwap'
  params: {
    computerName: wap1name
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    ADFSServerIP: adfs1IP
    EXServerIP: EX1IP
    ExternaldomainName: ExternaldomainName
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    configureotheradfs
    deployWAP1VM
  ]
}

module deployWAP2VM 'nestedtemplates/1nic-1disk-vm.bicep' = {
  name: 'deployWAP2VM'
  params: {
    computerName: wap2name
    computerIP: wap2IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: WAPOSVersion
    licenseType: WindowsServerLicenseType
    VMSize: WAP2VMSize
    vnetName: DMZVNet2Name
    subnetName: DMZVNet2subnet1Name
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: Location2
  }
  dependsOn: [
    configureotheradfs
  ]
}

module configureotherwap 'nestedtemplates/wap.bicep' = {
  name: 'configureotherwap'
  params: {
    computerName: wap2name
    TimeZone: TimeZone
    NetBiosDomain: NetBiosDomain
    ADFSServerIP: adfs1IP
    EXServerIP: EX2IP
    ExternaldomainName: ExternaldomainName
    IssuingCAName: IssuingCAName
    RootCAName: RootCAName
    location: Location2
    adminUsername: adminUsername
    adminPassword: adminPassword
    artifactsLocation: artifactsLocation
    artifactsLocationSasToken: artifactsLocationSasToken
  }
  dependsOn: [
    configurefirstwap
    deployWAP2VM
  ]
}

module createpublicdns 'nestedtemplates/PublicDNSZone.bicep' = {
  name: 'createpublicdns'
  params: {
    ZoneName: ExternaldomainName
    WEBRecord: 'www'
    OCSPRecord: 'ocsp'
    OWARecord: 'owa2019'
    AutoDiscoverRecord: 'autodiscover'
    OutlookRecord: 'outlook2019'
    EASRecord: 'eas2019'
    SMTP1Record: 'smtp1'
    SMTP2Record: 'smtp2'
    ADFSRecord: 'adfs'
    OCSPPublicIP: reference('DeployAzureFirewall1').outputs.OCSPPublicIP.value
    WEBPublicIP: reference('DeployAzureFirewall1').outputs.WEBPublicIP.value
    WAP1PublicIP: reference('DeployAzureFirewall1').outputs.WAPPublicIP.value
    WAP2PublicIP: reference('DeployAzureFirewall2').outputs.WAPPublicIP.value
    SMTP1PublicIP: reference('DeployAzureFirewall1').outputs.SMTPPublicIP.value
    SMTP2PublicIP: reference('DeployAzureFirewall2').outputs.SMTPPublicIP.value
  }
  dependsOn: [
    DeployAzureFirewall1
    DeployAzureFirewall2
  ]
}

module createprivatedns 'nestedtemplates/PrivateDNSZone.bicep' = {
  name: 'createprivatedns'
  params: {
    ZoneName: ExternaldomainName
    vnet1Name: DMZVNet1Name
    vnet2Name: DMZVNet2Name
    ADFSRecord: 'adfs'
    ADFS1PrivateIP: adfs1IP
    ADFS2PrivateIP: adfs2IP
  }
  dependsOn: [
    DMZVNet1
    DMZVNet2
    createpublicdns
  ]
}
