# Docker On Linux

Click the button below to deploy

[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDocker-on-Linux%2Fazuregovdeploy.json)

The Template deploys the folowing:

- 1 - D4s_v3 Red Hat VM with Docker

The deployment leverages Desired State Configuration scripts to further customize the following:

Remote Desktop
- Download RDP
- Install RDP

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- Location1. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) OS Version
- VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.