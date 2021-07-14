# Additional Domain Controller from Image
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAdditional-DomainController-from-Image%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2FDevelopment%2FAdditional-DomainController-from-Image%2Fazuredeploy.json)

This Templates deploys a Single Forest/Domain:

- 1 - Domain Controller

Parameters that support changes
- TimeZone.  Select an appropriate Time Zone.
- DCName.  Domain Controller Name
- DCIP.  Domain Controller IP Address
- ExistingDCIP.  Any Existing Domain Controller IP Address
- AD Drive Letter.  Drive Letter for NTDS Database/Logs and SYSVOL directories.
- DCVNetName.  Virtual Network Name
- DCSubnetName.  Subnet Name
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- Sub DNS Domain.  OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT )
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- Internal Domain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- InternalTLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- ImageRG.  Images Resource Group Name
- DC1ImageName.  Enter the Image Name that the Domain Controller should be based on.
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.