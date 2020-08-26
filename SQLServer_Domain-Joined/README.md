# SQL Server Domain-Joined Lab

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FSQLServer_Domain-Joined%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FSQLServer_Domain-Joined%2Fazuregovdeploy.json)

This Templates IS MEANT TO BE USED AS AN ADD-ON to the following labs due to its Domain Membership:
**** THE PARAMETERS SPECIFIED FOR THIS ADD-ON LAB MUST MATCH THE PARAMETERS OF THE BASE LAB THAT IT WILL BE ADDED TO ****

- 1-Forest_1-DomainController_1-Workstation
- 1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2010-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2010-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2013-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2013-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2016-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2016-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2019-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2019-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations

The Template deploys the folowing:

- 1 - Domain Joined SQL Server

The deployment leverages Desired State Configuration scripts to further customize the following:

SQL Deployment
- Installs SQL Server 2017/2019 based on selection
- Installs SQL Management Studio

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- SQLSASURL.  Enter a valid URL that points to the SQL 2019 or 2017 .ISO
- Location1. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- TLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- SQLOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) SQL OS Version
- SQLVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.