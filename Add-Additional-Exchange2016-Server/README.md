# Add Additional Exchange 2016 Server
Click a button below to deploy to the cloud of your choice

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FAdd-Additional-Exchange2016-Server%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FAdd-Additional-Exchange2016-Server%2Fazuregovdeploy.json)

This Templates IS MEANT TO BE USED AS AN ADD-ON to the following labs due to its Exchange/Domain Requirements:
**** THE PARAMETERS SPECIFIED FOR THIS ADD-ON LAB MUST MATCH THE PARAMETERS OF THE BASE LAB THAT IT WILL BE ADDED TO ****

- Exchange2016-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2016-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations

This Templates deploys the following:

- 2 - Additional Exchange 2016 Servers (1 within each AD Site)

The deployment leverages Desired State Configuration scripts to further customize the following:

Exchange
- Exchange 2016 OS Prerequisites
- Exchange 2016 Installation

Parameters that support changes
- Exchange2016ISOUrl.  You must enter a URL or created SAS URL that points to an Exchange 2016 ISO for this installation to be successful.
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- Location1. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Location2. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- TLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  16.1)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Virtual Network 2 (Example:  16.2)
- EX11VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- EX22VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.