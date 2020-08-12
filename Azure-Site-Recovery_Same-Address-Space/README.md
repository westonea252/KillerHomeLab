# Azure Site Recovery Lab (Same Address Space)

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FAzure-Site-Recovery_Same-Address-Space%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FAzure-Site-Recovery_Same-Address-Space%2Fazuregovdeploy.json)

This Templates deploys a Single Forest/Domain:

- 1 - Active Directory Forest/Domain
- 2 - Active Directory Sites
- 2 - Domain Controllers (1 within each AD Site)
- 2 - Domain Joined Servers (1 within each AD Site)
- 2 - Azure Key Vaults (1 within each Region)
- 2 - Recovery Services Vaults (1 within each Region)

The deployment leverages Desired State Configuration scripts to further customize the following:

AD OU Structure:
- [domain.com]
- -- Accounts
- --- End User
- ---- Office 365
- ---- Non-Office 365
- --- Admin
- --- Service
- -- Groups
- --- End User
- --- Admin
- -- Servers
- --- Servers2012R2
- --- Serverrs2016
- --- Servers2019
- -- MaintenanceServers
- -- MaintenanceWorkstations
- -- Workstations
- --- Windows10
- --- Windows7

Parameters that support changes
- Admin Object ID. Enter the Object ID for the Admin Account that will need access the Azure KeyVaults and Recovery Services Vaults.
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- Location1. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Location2. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- TLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Virtual Network 2 (Example:  10.2)
- Reverse Lookup1.  Enter first 2 octets of your desired Address Space in Reverse (Example:  1.10)
- Reverse Lookup2.  Enter first 2 octets of your desired Address Space in Reverse (Example:  2.10)
- Backup Object ID.  Choose "9a7b9a6d-0996-4d52-889f-46473877d766" for Azure Gov and "f40e18f0-6544-45c2-9d24-639a8bb3b41a" for Azure Commercial
- Key Vault1ID.  Enter a number make your KeyVault Unique (Example:  01)
- Key Vault2ID.  Enter a number make your KeyVault Unique (Example:  02)
- RS Vault1ID.  Enter a number make your Recovery Services Vault Unique (Example:  01)
- RS Vault2ID.  Enter a number make your Recovery Services Vault Unique (Example:  02)
- DC1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 1 OS Version
- DC2OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 2 OS Version
- SRV1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Root CA OS Version
- SRV2OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Issuing CA OS Version
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- DC2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- SRV1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- SRV2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.