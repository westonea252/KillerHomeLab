param(
    [String] [Parameter(Mandatory=$true)] $NamingConvention,
    [String] [Parameter(Mandatory=$true)] $TenantName,
    [String] [Parameter(Mandatory=$true)] $SubscriptionID,    
    [String] [Parameter(Mandatory=$true)] $AzureAdmin,
    [SecureString] [Parameter(Mandatory=$true)] $AzurePassword    
    )

[System.Management.Automation.PSCredential ]$Creds = New-Object System.Management.Automation.PSCredential ("$($AzureAdmin)", $AzurePassword)

$Tenant = Get-AzTenant | Where-Object {$_.Name -like "$TenantName"}

Connect-AzAccount -Credential $Creds

Install-Module Microsoft.Rdinfra.RdPowerShell -Force

Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com -Credential

New-RdsTenant -Name "$NamingConvention - Windows Virtual Desktop" -AadTenantId $Tenant.Id -AzureSubscriptionId $SubscriptionID