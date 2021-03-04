# Exchange 2016 KB5000871

Click a button below to deploy to the cloud of your choice

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FExchange2016-KB5000871%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FExchange2016-KB5000871%2Fazuregovdeploy.json)


The deployment also makes the following customizations:
- Downloads KB5000871
- Installs KB5000871
- Runs Health Check to generate a Report

Parameters that support changes
- Location2. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.

- CUPatchUrl.  Select the CU Patch based on current Exchange CU Level (CU19 Default or CU18)
- CUPatchUrl.  Use Default or enter customer URL for CU Health Check Script.
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.