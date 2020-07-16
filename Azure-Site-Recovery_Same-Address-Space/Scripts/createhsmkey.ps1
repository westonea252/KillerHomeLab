param(
    [string] [Parameter(Mandatory=$true)] $vaultName,
    [string] [Parameter(Mandatory=$true)] $KeyName,
    [string] [Parameter(Mandatory=$true)] $KeySize,
    [string] [Parameter(Mandatory=$true)] $KeyDestination
    )

$KeyVault = Get-AzKeyVault -VaultName $vaultName
$KeyExpires = (Get-Date).AddYears(2).ToUniversalTime()
$KeyNotBefore = (Get-Date).ToUniversalTime()

Add-AzKeyVaultKey -VaultName $KeyVault.VaultName -Name $Keyname -Expires $KeyExpires -NotBefore $KeyNotBefore -Size $KeySize -Destination $KeyDestination