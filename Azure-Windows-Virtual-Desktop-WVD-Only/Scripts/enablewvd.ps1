param(
    [String] [Parameter(Mandatory=$true)] $NamingConvention,
    [String] [Parameter(Mandatory=$true)] $TenantName,
    [String] [Parameter(Mandatory=$true)] $SubscriptionID
    )

$Tenant = Get-AzTenant | Where-Object {$_.Name -like "$TenantName"}

Install-Module Microsoft.Rdinfra.RdPowerShell -Force

Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com -Credential

New-RdsTenant -Name "$NamingConvention - Windows Virtual Desktop" -AadTenantId $Tenant.Id -AzureSubscriptionId $SubscriptionID