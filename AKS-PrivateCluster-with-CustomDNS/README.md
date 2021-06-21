# AKS Private Cluster with Custom DNS Server

Click a button below to deploy to the cloud of your choice

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAKS-PrivateCluster-with-CustomDNS%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAKS-PrivateCluster-with-CustomDNS%2Fazuredeploy.json)

[![Lab Diagram](Images/aks-private-hub-spoke.png)]

This Templates deploys a xxx:

- 3 - Virtual Networks

Parameters that support changes
- Vnet0ID.  Enter first 2 octets of your desired Address Space for OnPrem Virtual Network (Example:  10.1)
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Hub Virtual Network 1 (Example:  10.21)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Spoke Virtual Network 1 (Example:  10.20)