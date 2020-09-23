Configuration ASR
{
   param
   (
        [String]$VaultName,
        [String]$HyperVSite,
        [String]$TenantAdmin,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xPendingReboot # Used for Reboots

    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script ConfigureASR
        {
            SetScript =
            {
                # Create Credentials
                $Load = "$using:AdminCreds"
                $Password = $AdminCreds.GetNetworkCredential().Password

                # Install Azure PowerShell
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                Install-Module Az -Force
                Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
                Import-Module Az                

                # Store Hashed Credentials Locally
                New-Item -Path C:\AzureCreds -Type Directory
                $Password | ConvertFrom-SecureString | Out-File C:\AzureCreds\azureaccount.txt

                # Login to Azure
                $Azureusername = "$using:TenantAdmin"
                $Azurepassword = Get-Content C:\AzureCreds\azureaccount.txt
                $AzureCreds = New-Object -typename System.Management.Automation.PSCredential -argumentlist $Azureusername, ($Azurepassword | ConvertTo-SecureString)
                Connect-AzAccount -Environment AzureUSGovernment -Credential $AzureCreds
​
                # Get Vault
                $Vault = Get-AzRecoveryServicesVault -Name "$using:VaultName"

                # Create Hyper-V Site
                New-AzRecoveryServicesAsrFabric -Type HyperVSite -Name "$using:HyperVSite"

                # Generate and Download Registration Key
                $SiteIdentifier = Get-AzRecoveryServicesAsrFabric -Name "$using:HyperVSite" | Select-Object -ExpandProperty SiteIdentifier
                $path = Get-AzRecoveryServicesVaultSettingsFile -Vault "$using:Vault" -SiteIdentifier $SiteIdentifier -SiteFriendlyName "$using:HyperVSite"
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

        xPendingReboot AfterRoleInstallation
        {
            Name       = 'AfterRoleInstallation'
        }

     }
  }