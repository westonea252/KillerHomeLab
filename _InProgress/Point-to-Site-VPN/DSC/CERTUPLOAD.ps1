Configuration CERTUPLOAD
{
   param
   (
        [String]$TenantDomain,
        [String]$Environment,
        [System.Management.Automation.PSCredential]$Admincreds,
        [System.Management.Automation.PSCredential]$Tenantcreds
    )

    [System.Management.Automation.PSCredential ]$NewTenantCreds = New-Object System.Management.Automation.PSCredential ("$($Tenantcreds.UserName)@${TenantDomain}", $Tenantcreds.Password)

    Node localhost
    {

        Script InstallAzModule
        {
            SetScript =
            {
                # Install Azure PowerShell
                $NuGetCheck = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
                IF ($NuGetCheck -eq $Null) {Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}
                $AzModCheck = Get-Module -Name Az -ErrorAction SilentlyContinue
                IF ($AzModCheck -eq $Null) {
                # Install Az Module
                Install-Module Az -Force

                # Set Execution Policy
                Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

                # Import Az Module
                Import-Module Az  

                # Create Hashed Credentials Location
                New-Item -Path C:\AzureCreds -Type Directory
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $Admincreds
        }

        Script UploadCert
        {
            SetScript =
            {                 
                # Load Credentials
                $Creds = $using:NewTenantCreds

                # Convert Secure to Plaintext
                $PlainPassword = $Creds.GetNetworkCredential().Password
                $PlainUserName = $Creds.GetNetworkCredential().UserName
                
                # Store Plaintext Values (Testing Only)
                $PlainPassword | fl > C:\CredsPlainPassword.txt
                $PlainUserName | fl > C:\CredsPlainUserName.txt

                # Convert Plaintext to Secure
                $SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force
                
                # Store Secure Values (Testing Only)
                $SecurePassword | fl > C:\SecurePassword.txt

                # Convert Secure to Encrypted File
                $EncryptedPassword = ConvertFrom-SecureString -SecureString $SecurePassword | Out-File C:\Azurecreds\EncryptedPassword.txt

                # Create Azure Credentials
                $AzureUserName = $PlainUserName
                $AzurePassword = Get-Content C:\AzureCreds\EncryptedPassword.txt
                $AzureCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AzureUserName, ($AzurePassword | ConvertTo-SecureString)

                Connect-AzAccount -Environment "$using:Environment" -Credential $AzureCreds

                New-Item -Path C:\TestAfterLoginLogin -Type Directory                ​
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]InstallAzModule'
        }
     }
  }