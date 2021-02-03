# Azure Firewall

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAzure-Firewall%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAzure-Firewall%2Fazuredeploy.json)

The Template deploys the folowing:

- 1 - DMZ Virtual Network
- 1 - APP Virtual Network (6 Subnets - WEB, EX, DB, AD, ID, IF)
- 1 - Azure Firewall
- 3 - Azure Firewall Public IP Address
- 1 - Bastion Host (DMZ VNet)
- 6 - Network Security Groups
- 6 - Application Security Groups
- 1 - IIS Server

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Seer License Type (Example:  Windows_Server or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- DMZVNet1ID.  Enter first 2 octets of your desired Address Space for your DMZ Virtual Network 1 (Example:  10.0)
- APPVNet1ID.  Enter first 2 octets of your desired Address Space for your DMZ Virtual Network 1 (Example:  10.1)
- OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) OS Version
- VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.