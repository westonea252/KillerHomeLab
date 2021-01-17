# Hyper-V Nested Virtualization Lab

Click the button below to deploy

[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FHyperV-Nested-Virtualization%2Fazuregovdeploy.json)

The Template deploys the folowing:

- 1 - D8s_v3 VM with Hyper-V Enabled

The deployment leverages Desired State Configuration scripts to further customize the following:

Azure Site Recovery
- Install Azure PowerShell on Hyper-V Host
- Create Recovery Services Vault
- Create ASR Hyper-V Site
- Download ASR Regisration Key

Hyper-V Deployment
- Create DataDisk
- Install HyperV
- Create Virtual Switch
- Create NAT Gateway
- Create NAT Network

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- Tenant Admin.  Enter a valid Azure Tenant Admin
- Tenant Password.  Enter a valid Azure Tenant Password
- HyperVSite.  Enter a valid name for a Hyper-V Site
- Location1. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- HyperVSubnetID.  Enter first 3 octets of your desired Address Space for HyperV VNet (Example:  192.168.1)
- HVOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Hyper-V OS Version
- HVVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.