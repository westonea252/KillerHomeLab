# WindowsRouter-to-Azure-VPN

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FWindowsRouter-to-Azure-VPN%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FWindowsRouter-to-Azure-VPN%2Fazuregovdeploy.json)

This Templates deploys a Azure to OnPrem VPN with a Windows Router used as the On-Premise VPN Device:

- 2 - Resource Groups
- 2 - Virtual Networks
- 1 - Virtual Network Gateway
- 2 - Bastion Hosts
- 1 - Windows Router (VM with 2 NIC's and Public IP)
- 1 - Network Security Group
- 1 - Local Network Gateway
- 1 - Connection
- 1 - Route Table
- 12 - Virtual Machines
-- 1 - Domain Controller (OnPrem)
-- 1 - Domain Controller (Azure)
-- 1 - Root CA Server (OnPrem)
-- 1 - Issuing CA Server (Azure)
-- 1 - OCSP Server (Azure)
-- 1 - File Server (Azure)
-- 1 - Exchange Server (Azure)
-- 1 - AD Connect Server (Azure)
-- 1 - ADFS Server (Azure)
-- 1 - WAP Connect Server (Azure)
-- 1 - Workstation (OnPrem)
-- 1 - Workstation (Azure)

The deployment leverages Desired State Configuration scripts to further customize the following:

Windows Features
- Windows Routing Remote Access configured as a Site-2-Site VPN

PKI
- 1 - Offline Root Certificate Authority Server
- 1 - Issuing Certificate Authority Server
- 1 - Online Certificate Status Protocol Server
- Offline Root CA Configuaration
- Issuing CA Configuration
- OCSP Configuaration

Parameters that support changes
- TimeZone.  Select an appropriate Time Zone.
- Location2.  Location for Azure Resources.
- Site1RG. Resource Group Name for On-Prem Resources
- Site2RG. Resource Group Name for Azure Resources
- Exchange Org Name. Enter a name that will be used for your Exchange Organization Name.
- To Email.  Please provide a working email address that the Trusted Certificate Authority Chain Can be sent to.  These certificates will allow access to Exchange Services like OWA, EAS and Outlook without Certificate Security warnings. (Depending on What Public IP you get initially.  Exchange mailflow may be blocked if it's blacklisted)
- AdminUsername.  Enter a valid Admin Username
- AdminPassword.  Enter a valid Admin Password
- SharedKey.  Enter a key used as the VPN Pre-Shared Key.
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- WindowsClientLicenseType.  Choose Windows Client License Type (Example:  Windows_Client or None)
- Exchange2019ISOUrl.  You must enter a URL or created SAS URL that points to an Exchange 2019 ISO for this installation to be successful.
- AzureADConnectDownloadUrl.  Download location for Azure AD Connect.
- OP Naming Convention. Enter a name that will be used as a naming prefix for (On-Prem Servers, VNets, etc) you are using.
- AZ Naming Convention. Enter a name that will be used as a naming prefix for (Azure Servers, VNets, etc) you are using.
- Sub DNS BaseDN.  OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA )
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- Internal Domain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- InternalTLD.  Select a valid Top-Level Domain for your Internal Domain using the Pull-Down Menu.
- External Domain.  Enter a valid External Domain (Exmaple:  killerhomelab)
- ExternalTLD.  Select a valid Top-Level Domain for your External Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for On-Prem Virtual Network(Example:  10.1)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Azure Virtual Network(Example:  10.2)
- Root CA Name.  Enter a Name for your Root Certificate Authority
- Issuing CA Name.  Enter a Name for your Issuing Certificate Authority
- RootCAHashAlgorithm.  Hash Algorithm for Offline Root CA
- RootCAKeyLength.  Key Length for Offline Root CA
- IssuingCAHashAlgorithm.  Hash Algorithm for Issuing CA
- IssuingCAKeyLength.  Key Length for Issuing CA
- ROUTEROSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Router OS Version
- DC1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 1 OS Version
- DC2OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 2 OS Version
- RCAOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Root CA OS Version
- ICAOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Issuing CA OS Version
- OCSPOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) OCSP OS Version
- FSOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) File ShareWiteness OS Version
- EXOSVersion.  Exchange Servers OS Version is not configurable and set to 2019-Datacenter (Windows 2019).
- ADCOSVersion.  AD Connect Server OS Version is not configurable and set to 2019-Datacenter (Windows 2019).
- WAPOSVersion.  Web Application Proxy Server OS Version is not configurable and set to 2019-Datacenter (Windows 2019).
- ADFSOSVersion.  ADFS Server OS Version is not configurable and set to 2019-Datacenter (Windows 2019).
- WK1OSVersion.  Workstation1 OS Version is not configurable and set to 19h1-pro (Windows 10).
- WK2OSVersion.  Workstation2 OS Version is not configurable and set to 19h1-pro (Windows 10).
- ROUTERVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- DC2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- RCAVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- ICAVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- OCSPVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- FS1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- EX1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- ADC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- ADFS1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- WAP1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- WK1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
 on which Region the VM is deployed.
- WK2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.