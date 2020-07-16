param(
    [string] [Parameter(Mandatory=$true)] $vaultName,
    [string] [Parameter(Mandatory=$true)] $KeyName,
    [string] [Parameter(Mandatory=$true)] $DESName,
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $Location    
    )

$KeyVault = Get-AzKeyVault -VaultName $vaultName
$Key = Get-AzKeyVaultKey -VaultName $KeyVault.VaultName -Name $KeyName

$desConfig = New-AzDiskEncryptionSetConfig -Location $Location -SourceVaultId $KeyVault.ResourceId -KeyUrl $key.Key.Kid -IdentityType SystemAssigned

$des = New-AzDiskEncryptionSet -Name $DESName -ResourceGroupName $ResourceGroupName -InputObject $desConfig
Set-AzKeyVaultAccessPolicy -VaultName $KeyVault.VaultName -ObjectId $des.Identity.PrincipalId -PermissionsToKeys wrapkey,unwrapkey,get