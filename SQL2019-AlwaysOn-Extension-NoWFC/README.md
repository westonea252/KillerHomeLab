# SQL 2019 Always-On Lab Extension No WFC

Click the button below to deploy

[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FSQL2019-AlwaysOn-Extension-NoWFC%2Fazuregovdeploy.json)

This Templates deploys a Single Forest/Domain with a SQL Always On Windows Failover Cluster:

- 1 - Active Directory Forest/Domain
- 1 - Domain Controller
- 1 - Domain Joined Tools Machine
- 1 - Managed Availability Set
- 2 - D8s_v3 Domain Joined VM's with SQL Server 2019 Datacenter on Windows Server 2019 Datacenter

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
- AdminUsername.  Enter a valid Admin Username
- AdminPassword.  Enter a valid Admin Password
- LicenseType.  Choose Windows_Server if you already have a WindowsServer License or None if you don't
- AvailabilitySetName.  Enter a Availability Set Name
- LoadBalancerName.  Enter a Load Balanccer Name
- ServiceAccount.  SQL Service Account Name
- InstallAccount.  SQL Install Account Name
- OSDiskType.  Storage Sku (Example:  Premium_LRS)
- SQLClusterName.  Windows Failover Cluster Name
- SQLAGName.  SQL Availability Group Name
- SQLAPName.  SQL Access Point Name
- SQLNode1.  Enter a valid SQL Node Number which is used to generate the SQL VM1 Name
- SQLNode2.  Enter a valid SQL Node Number which is used to generate the SQL VM2 Name
- sqllastapoctet.  Enter the desired last IP octet for SQL Access Point (Example:  10).
- sql1lastmgmtoctet.  Enter the desired last IP octet for SQL VM1's Management NIC (Example:  11).
- sql2lastmgmtoctet.  Enter the desired last IP octet for SQL VM2's Management NIC (Example:  12).
- sql1lastdataoctet.  Enter the desired last IP octet for SQL VM1's Data NIC (Example:  11).
- sql2lastdataoctet.  Enter the desired last IP octet for SQL VM2's Data NIC (Example:  12).
- sql1DGlastdataoctet.  Enter the desired last IP octet for SQL VM1's Data NIC'S Default Gateway (Example:  1).
- sql2DGlastdataoctet.  Enter the desired last IP octet for SQL VM2's Data NIC'S Default Gateway (Example:  1).
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- SubDNSDomain.  OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT )
- SubDNSBaseDN.  OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA )
- NetBiosDomain.  Enter a valid Net Bios Domain Name (Example:  sub1).
- InternalDomain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- TLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- DC1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 1 OS Version
- ToolsOSVersion.  elect 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Tools OS Version
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- ToolsVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- SQLVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.