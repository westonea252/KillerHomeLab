param(
    [string] [Parameter(Mandatory=$true)] $DESName,
    [string] [Parameter(Mandatory=$true)] $EncryptionType,    
    [string] [Parameter(Mandatory=$true)] $VMName,          
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName
    )

    $EncryptionKeyType = $EncryptionType
    $vm = Get-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName -Status
    $OSDisk = Get-AzDisk -Name $vm.StorageProfile.OsDisk.Name
    $DataDiskCheck = $vm.StorageProfile.DataDisks
    IF ($OSDisk.Encryption.Type -ne $EncrptionKeyType){
    Stop-AzVm -Name $VMName -ResourceGroupName $ResourceGroupName -Force
    $des = Get-AzDiskEncryptionSet -Name $DESName -ResourceGroupName $ResourceGroupName
    New-AzDiskUpdateConfig -EncryptionType $EncryptionKeyType -DiskEncryptionSetId $des.Id | Update-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $OSDisk.Name
    }
    IF ($Null -ne $DataDiskCheck) {
    $DataDisk = Get-AzDisk -Name $vm.StorageProfile.DataDisk[0].Name
    New-AzDiskUpdateConfig -EncryptionType $EncryptionKeyType -DiskEncryptionSetId $des.Id | Update-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DataDisk.Name
    }
    IF ($VM.PowerState -eq 'VM deallocated') {Start-AzVm -Name $VMName -ResourceGroupName $ResourceGroupName}