# DevOps Server 2020 Lab

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAzure_DevOps_Server_2020%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAzure_DevOps_Server_2020%2Fazuredeploy.json)

The Template deploys the folowing:

- 1 - DevOps Server 2020 Server

The deployment leverages Desired State Configuration scripts to further customize the following:

 Deployment
- Installs DevOps Server 2020

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Seer License Type (Example:  Windows_Server or None)
- DOSASURL.  Enter a valid URL that points to the SQL 2019 or 2017 .ISO
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- SQLOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) SQL OS Version
- SQLVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.