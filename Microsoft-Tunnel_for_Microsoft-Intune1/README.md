# The Killer Home Lab

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAzure-Firewall%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAzure-Firewall%2Fazuredeploy.json)

The Template deploys the folowing:

- 1 - DMZ Virtual Network
- 1 - APP Virtual Network (7 Subnets - WEB, EX, DB, AD, ID, IF, WK)
- 1 - Azure Firewall
- 4 - Azure Firewall Public IP Address
- 1 - Bastion Host (DMZ VNet)
- 7 - Network Security Groups
- 6 - Application Security Groups

The deployment leverages Desired State Configuration scripts to further customize the following:

Web Server
- 1 - IIS Server
- Install IIS

Active Directory
- 2 - Domain Controllers (1 within each AD Site)
- Sample OU Structure
- DNS Record Config
- AD Site Creation

SQL Deployment
- 1 - Domain Joined SQL Server
- Installs SQL Server 2017/2019 based on selection
- Installs SQL Management Studio

PKI
- 1 - Offline Root Certificate Authority Server
- 1 - Issuing Certificate Authority Server
- 1 - Online Certificate Status Protocol Server
- Offline Root CA Configuaration
- Issuing CA Configuration
- OCSP Configuaration

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- WindowsClientLicenseType.  Choose Windows Client License Type (Example:  Windows_Client or None)
- SQLSASURL.  Enter a valid URL that points to the SQL 2019 or 2017 .ISO
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Sub DNS Domain.  OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT )
- Sub DNS BaseDN.  OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA )
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- Internal Domain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- TLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- DMZVNet1ID.  Enter first 2 octets of your desired Address Space for your DMZ Virtual Network 1 (Example:  10.0)
- APPVNet1ID.  Enter first 2 octets of your desired Address Space for your APP Virtual Network 1 (Example:  10.1)
- APPVNet2ID.  Enter first 2 octets of your desired Address Space for your APP Virtual Network 2 (Example:  10.2)
- Reverse Lookup1.  Enter first 2 octets of your desired Address Space in Reverse (Example:  1.10)
- Reverse Lookup2.  Enter first 2 octets of your desired Address Space in Reverse (Example:  2.10)
- Root CA Name.  Enter a Name for your Root Certificate Authority
- Issuing CA Name.  Enter a Name for your Issuing Certificate Authority
- RootCAHashAlgorithm.  Hash Algorithm for Offline Root CA
- RootCAKeyLength.  Key Length for Offline Root CA
- IssuingCAHashAlgorithm.  Hash Algorithm for Issuing CA
- IssuingCAKeyLength.  Key Length for Issuing CA
- WEBOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) OS Version
- DC1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 1 OS Version
- DC2OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 2 OS Version
- SQLOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) SQL OS Version
- RCAOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Root CA OS Version
- ICAOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Issuing CA OS Version
- OCSPOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) OCSP OS Version
- WK1OSVersion.  Workstation1 OS Version is not configurable and set to 19h1-pro (Windows 10).
- WEBVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- DC2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- SQLVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- RCAVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- ICAVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- OCSPVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- WK1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.