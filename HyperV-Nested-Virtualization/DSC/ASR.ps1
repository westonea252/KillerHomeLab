Configuration ASR
{
   param
   (
        [String]$VaultName,
        [String]$HyperVSite,
        [System.Management.Automation.PSCredential]$Admincreds,
        [System.Management.Automation.PSCredential]$Tenantcreds
    )

    Import-DscResource -Module xPendingReboot # Used for Reboots

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script InstallAzModule
        {
            SetScript =
            {
                # Install Azure PowerShell
                $NuGetCheck = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
                IF ($NuGetCheck -eq $Null) {Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}
                $AzModCheck = Get-Module -Name Az.Accounts -ErrorAction SilentlyContinue
                IF ($AzModCheck -eq $Null) {Install-Module Az -Force}
                IF ($AzModCheck -eq $Null) {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force}
                IF ($AzModCheck -eq $Null) {Import-Module Az}                
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $Admincreds
        }

        Script ConfigureASR
        {
            SetScript =
            {
                # Create Credentials
                $Load = "$using:TenantCreds"
                $AzureCreds = $TenantCreds

                # Load Azure PowerShell
                $AzModCheck = Get-Module -Name Az.Accounts -ErrorAction SilentlyContinue
                IF ($AzModCheck -ne $Null) {Import-Module Az}                
                
                Connect-AzAccount -Environment AzureUSGovernment -Credential $AzureCreds
​
                # Get Vault
                $Vault = Get-AzRecoveryServicesVault -Name "$using:VaultName"

                # Create Hyper-V Site
                $FabricCheck = Get-AzRecoveryServicesAsrFabric -Name "$using:HyperVSite"
                IF ($FabricCheck -eq $Null) {New-AzRecoveryServicesAsrFabric -Type HyperVSite -Name "$using:HyperVSite"}

                # Generate and Download Registration Key
                $SiteIdentifier = Get-AzRecoveryServicesAsrFabric -Name "$using:HyperVSite" | Select-Object -ExpandProperty SiteIdentifier
                $path = Get-AzRecoveryServicesVaultSettingsFile -Vault "$using:Vault" -SiteIdentifier $SiteIdentifier -SiteFriendlyName "$using:HyperVSite"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]InstallAzModule'
        }

        xPendingReboot AfterRoleInstallation
        {
            Name       = 'AfterRoleInstallation'
        }

     }
  }