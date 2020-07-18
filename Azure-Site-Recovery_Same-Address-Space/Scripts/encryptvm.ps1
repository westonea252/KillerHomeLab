param(
    [string] [Parameter(Mandatory=$true)] $DESName,
    [string] [Parameter(Mandatory=$true)] $VMName,          
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $EncryptionType    
    )

    $des = Get-AzDiskEncryptionSet -Name $DESName -ResourceGroupName $ResourceGroupName
    $vm = Get-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName
    $OSDisk = Get-AzDisk -name $vm.StorageProfile.OsDisk.Name
    $DataDisk = Get-AzDisk -name $vm.StorageProfile.DataDisks[0].Name
    Stop-AzVm -Name $VMName -ResourceGroupName $ResourceGroupName -Force
    IF ($OSDisk.Encryption.Type -ne $EncryptionType) {New-AzDiskUpdateConfig -EncryptionType $EncryptionType -DiskEncryptionSetId $des.Id | Update-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $OSDisk.Name}
    IF ($DataDisk.Encryption.Type -ne $EncryptionType) {New-AzDiskUpdateConfig -EncryptionType $EncryptionType -DiskEncryptionSetId $des.Id | Update-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DataDisk.Name}
    Start-AzVm -Name $VMName -ResourceGroupName $ResourceGroupName