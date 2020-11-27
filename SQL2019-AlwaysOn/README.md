# SQL 2019 Always-On Lab

Click the button below to deploy

[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FSQL2019-AlwaysOn%2Fazuregovdeploy.json)

This Template CAN BE used AS AN ADD-ON to the following labs:
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
- PKI_2-Tier_CA_With_OCSP_1-Workstation

The Template deploys the folowing:

- 1 - Managed Availability Set
- 2 - D8s_v3 Domain Joined VM's with SQL Server 2019 Datacenter on Windows Server 2019 Datacenter

The deployment leverages Desired State Configuration scripts to further customize the following:

Windows Features
- Windows Failover Cluster

SQL Deployment
- Configures SQL Always On

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- OSDiskType.  Storage Sku (Example:  Premium_LRS)
- SQLNode1.  Enter a valid SQL Node Number which is used to generate the SQL VM1 Name
- SQLNode2.  Enter a valid SQL Node Number which is used to generate the SQL VM2 Name
- sql1lastmgmtoctet.  Enter the desired last IP octet for SQL VM1's Management NIC (Example:  11).
- sql2lastmgmtoctet.  Enter the desired last IP octet for SQL VM2's Management NIC (Example:  12).
- sql1lastdataoctet.  Enter the desired last IP octet for SQL VM1's Data NIC (Example:  11).
- sql1DGlastdataoctet.  Enter the desired last IP octet for SQL VM1's Data NIC'S Default Gateway (Example:  1).
- sql2lastdataoctet.  Enter the desired last IP octet for SQL VM2's Data NIC (Example:  12).
- sql2DGlastdataoctet.  Enter the desired last IP octet for SQL VM2's Data NIC'S Default Gateway (Example:  1).
- Location. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Sub DNS Domain.  OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT )
- Sub DNS BaseDN.  OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA )
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  sub1).
- Internal Domain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- TLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- SQLVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.