Param(
    [string] [Parameter(Mandatory=$true)] $RSVaultName,
    [string] [Parameter(Mandatory=$true)] $RecoveryVNet,
    [string] [Parameter(Mandatory=$true)] $Site1Name,
    [string] [Parameter(Mandatory=$true)] $Site2Name,
    [string] [Parameter(Mandatory=$true)] $SourceRG,
    [string] [Parameter(Mandatory=$true)] $location1,
    [string] [Parameter(Mandatory=$true)] $location2,
    [string] [Parameter(Mandatory=$true)] $vmName
)

$VM = Get-AzVM -ResourceGroupName $SourceRG -Name $vmname
$OSDiskVhdURI = $VM.StorageProfile.OsDisk.Vhd
$DataDisk1VhdURI = $VM.StorageProfile.DataDisks[0].Vhd

$VaultForSite1 = Get-AzRecoveryServicesVault -Name $RSVaultName -ResourceGroupName $SourceRG -ErrorAction 0
Set-AzRecoveryServicesVaultProperty -SoftDeleteFeatureState Disable -VaultId $VaultForSite1.ID
Set-AzRecoveryServicesAsrVaultContext -Vault $VaultForSite1

#Create Primary ASR fabric
$primaryfabriccheck = Get-AzRecoveryServicesAsrFabric -Name $Site1Name-ASR-Fabric -ErrorAction 0
IF ($primaryfabriccheck -eq $null) {$PrimaryFabricASRJob = New-AzRecoveryServicesAsrFabric -Azure -Location $location1 -Name $Region1-ASR-Fabric}
ELSE {$PrimaryFabricASRJob = Get-AzRecoveryServicesAsrFabric -Name $Site1Name-ASR-Fabric}

# Track Job status to check for completion
while (($PrimaryFabricASRJob.State -eq "InProgress") -or ($PrimaryFabricASRJob.State -eq "NotStarted")){
        #If the job hasn't completed, sleep for 10 seconds before checking the job status again
        sleep 10;
        $PrimaryFabricASRJob = Get-AzRecoveryServicesAsrJob -Job $PrimaryFabricASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $PrimaryFabricASRJob.State

$PrimaryFabric = Get-AzRecoveryServicesAsrFabric -Name $Site1Name-ASR-Fabric

#Create Recovery ASR fabric
$recoveryfabriccheck = Get-AzRecoveryServicesAsrFabric -Name $Site2Name-ASR-Fabric -ErrorAction 0
IF ($recoveryfabriccheck -eq $null) {$RecoveryFabricASRJob = New-AzRecoveryServicesAsrFabric -Azure -Location $location2 -Name $Site2Name-ASR-Fabric}
ELSE {$RecoveryFabricASRJob = Get-AzRecoveryServicesAsrFabric -Name $Site2Name-ASR-Fabric}

# Track Job status to check for completion
while (($RecoveryFabricASRJob.State -eq "InProgress") -or ($RecoveryFabricASRJob.State -eq "NotStarted")){
        sleep 10;
        $RecoveryFabricASRJob = Get-AzRecoveryServicesAsrJob -Job $RecoveryFabricASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $RecoveryFabricASRJob.State

$RecoveryFabric = Get-AzRecoveryServicesAsrFabric -Name $Site2Name-ASR-Fabric

#Create a Protection container in the primary Azure region (within the Primary fabric)
$containercheck = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $PrimaryFabric -ErrorAction 0
IF ($containercheck -eq $null) {$ContainerASRJob = New-AzRecoveryServicesAsrProtectionContainer -InputObject $PrimaryFabric -Name $Site1Name-ProtectionContainer}
ELSE {$ContainerASRJob = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $PrimaryFabric}

#Track Job status to check for completion
while (($ContainerASRJob.State -eq "InProgress") -or ($ContainerASRJob.State -eq "NotStarted")){
        sleep 10;
        $ContainerASRJob = Get-AzRecoveryServicesAsrJob -Job $ContainerASRJob
}

Write-Output $ContainerASRJob.State

$PrimaryProtContainer = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $PrimaryFabric -Name $Site1Name-ProtectionContainer

#Create a Protection container in the recovery Azure region (within the Recovery fabric)
$recoverycontainercheck = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $RecoveryFabric -ErrorAction 0
IF ($recoverycontainercheck -eq $null) {$RecoveryContainerASRJob = New-AzRecoveryServicesAsrProtectionContainer -InputObject $RecoveryFabric -Name $Site2Name-ProtectionContainer}
ELSE {$recoveryContainerASRJob = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $RecoveryFabric}

#Track Job status to check for completion
while (($RecoveryContainerASRJob.State -eq "InProgress") -or ($RecoveryContainerASRJob.State -eq "NotStarted")){
        sleep 10;
        $RecoveryContainerASRJob = Get-AzRecoveryServicesAsrJob -Job $RecoveryContainerASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"

Write-Output $RecoveryContainerASRJob.State

$RecoveryProtContainer = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $RecoveryFabric -Name $Site2Name-ProtectionContainer

#Create replication policy
$policycheck = Get-AzRecoveryServicesAsrPolicy -Name $Site1Name-Policy -ErrorAction 0
IF ($policycheck -eq $null) {$PolicyASRJob = New-AzRecoveryServicesAsrPolicy -AzureToAzure -Name $Region1-Policy -RecoveryPointRetentionInHours 24 -ApplicationConsistentSnapshotFrequencyInHours 4}
ELSE {$PolicyASRJob = Get-AzRecoveryServicesAsrPolicy -Name $Site1Name-Policy}

#Track Job status to check for completion
while (($PolicyASRJob.State -eq "InProgress") -or ($PolicyASRJob.State -eq "NotStarted")){
        sleep 10;
        $PolicyASRJob = Get-AzRecoveryServicesAsrJob -Job $PolicyASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $PolicyASRJob.State

$ReplicationPolicy = Get-AzRecoveryServicesAsrPolicy -Name $Site1Name-Policy

#Create Protection container mapping between the Primary and Recovery Protection Containers with the Replication policy
$containerMappingcheck = Get-AzRecoveryServicesAsrProtectionContainerMapping -Name $Site1Name-PrimaryToRecovery -ProtectionContainer $PrimaryProtContainer -ErrorAction 0
IF ($containermappingcheck -eq $null) {$ContainerMappingASRJob = New-AzRecoveryServicesAsrProtectionContainerMapping -Name $Site1Name-PrimaryToRecovery -Policy $ReplicationPolicy -PrimaryProtectionContainer $PrimaryProtContainer -RecoveryProtectionContainer $RecoveryProtContainer}
ELSE {$ContainerMappingASRJob = Get-AzRecoveryServicesAsrProtectionContainerMapping -Name $Site1Name-PrimaryToRecovery -ProtectionContainer $PrimaryProtContainer}

#Track Job status to check for completion
while (($ContainerMappingASRJob.State -eq "InProgress") -or ($ContainerMappingASRJob.State -eq "NotStarted")){
        sleep 10;
        $ContainerMappingASRJob = Get-AzRecoveryServicesAsrJob -Job $ContainerMappingASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $ContainerMappingASRJob.State

$EusToWusPCMapping = Get-AzRecoveryServicesAsrProtectionContainerMapping -ProtectionContainer $PrimaryProtContainer -Name $Site1Name-PrimaryToRecovery

#Create Protection container mapping (for failback) between the Recovery and Primary Protection Containers with the Replication policy
$RecoverycontainerMappingcheck = Get-AzRecoveryServicesAsrProtectionContainerMapping -Name $Site1Name-RecoveryToPrimary -ProtectionContainer $RecoveryProtContainer -ErrorAction 0
IF ($Recoverycontainermappingcheck -eq $null) {$RecoveryContainerMappingASRJob = New-AzRecoveryServicesAsrProtectionContainerMapping -Name $Site1Name-RecoveryToPrimary -Policy $ReplicationPolicy -PrimaryProtectionContainer $RecoveryProtContainer -RecoveryProtectionContainer $PrimaryProtContainer}
ELSE {$RecoveryContainerMappingASRJob = Get-AzRecoveryServicesAsrProtectionContainerMapping -Name $Site1Name-RecoveryToPrimary -ProtectionContainer $RecoveryProtContainer}

#Track Job status to check for completion
while (($RecoveryContainerMappingASRJob.State -eq "InProgress") -or ($RecoveryContainerMappingASRJob.State -eq "NotStarted")){
        sleep 10;
        $RecoveryContainerMappingASRJob = Get-AzRecoveryServicesAsrJob -Job $RecoveryContainerMappingASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $RecoveryContainerMappingASRJob.State

#Create Cache storage account for replication logs in the primary region
$cachecheck = Get-AzStorageAccount -Name $Site1Name'cachestorage' -ResourceGroupName $SourceRG -ErrorAction 0
IF ($cachecheck -eq $null) {$CacheStorageAccount = New-AzStorageAccount -Name $Site1Name'cachestorage' -ResourceGroupName $SourceRG -Location $location1 -SkuName Standard_LRS -Kind Storage}
ELSE {$CacheStorageAccount = Get-AzStorageAccount -Name $Site1Name'cachestorage' -ResourceGroupName $SourceRG}

#Create Target storage account in the recovery region. In this case a Standard Storage account
$storagecheck = Get-AzStorageAccount -Name $Site2Name'targetstorage' -ResourceGroupName $SourceRG -ErrorAction 0
IF ($storagecheck -eq $null) {$TargetStorageAccount = New-AzStorageAccount -Name $Site2Name'targetstorage' -ResourceGroupName $SourceRG -Location $location2 -SkuName Standard_LRS -Kind Storage}
ELSE {$TargetStorageAccount = Get-AzStorageAccount -Name $Site2Name'targetstorage' -ResourceGroupName $SourceRG}

#Set Recovery Network in the recovery region
$RecoveryVnet = Get-AzVirtualNetwork -ResourceGroup $SourceRG -Name $RecoveryVNet
$RecoveryNetwork = $RecoveryVnet.Id

#Retrieve the virtual network that the virtual machine is connected to
#Get first network interface card(nic) of the virtual machine
$SplitNicArmId = $VM.NetworkProfile.NetworkInterfaces[0].Id.split("/")

#Extract resource name from the ResourceId of the nic
$NICname = $SplitNicArmId[-1]

#Get network interface details using the extracted resource group name and resource name
$NIC = Get-AzNetworkInterface -ResourceGroupName $SourceRG -Name $NICname

#Get the subnet ID of the subnet that the nic is connected to
$PrimarySubnet = $NIC.IpConfigurations[0].Subnet

# Extract the resource ID of the Azure virtual network the nic is connected to from the subnet ID
$PrimaryNetwork = (Split-Path(Split-Path($PrimarySubnet.Id))).Replace("\","/")

#Create an ASR network mapping between the primary Azure virtual network and the recovery Azure virtual network
$NetworkMappingASRJob = New-AzRecoveryServicesAsrNetworkMapping -AzureToAzure -Name $Site1Name-NWMapping -PrimaryFabric $PrimaryFabric -PrimaryAzureNetworkId $PrimaryNetwork -RecoveryFabric $RecoveryFabric -RecoveryAzureNetworkId $RecoveryNetwork

#Track Job status to check for completion
while (($NetworkMappingASRJob.State -eq "InProgress") -or ($NetworkMappingASRJob.State -eq "NotStarted")){
        sleep 10;
        $NetworkMappingASRJob = Get-AzRecoveryServicesAsrJob -Job $NetworkMappingASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $NetworkMappingASRJob.State 

#Create an ASR network mapping for failback between the recovery Azure virtual network and the primary Azure virtual network
$networkmappingcheck = Get-AzRecoveryServicesAsrNetworkMapping -Name $Site1Name-NWMapping -PrimaryFabric $PrimaryFabric -ErrorAction 0
IF ($networkmappingcheck -eq $null) {$networkmappingASRJob = New-AzRecoveryServicesAsrNetworkMapping -AzureToAzure -Name $Site2Name-NWMapping -PrimaryFabric $RecoveryFabric -PrimaryAzureNetworkId $RecoveryNetwork -RecoveryFabric $PrimaryFabric -RecoveryAzureNetworkId $PrimaryNetwork}
ELSE {$NetworkMappingASRJob = Get-AzRecoveryServicesAsrNetworkMapping -Name $Site1Name-NWMapping -PrimaryFabric $PrimaryFabric}

#Track Job status to check for completion
while (($networkmappingASRJob.State -eq "InProgress") -or ($networkmappingASRJob.State -eq "NotStarted")){
        sleep 10;
        $networkmappingASRJob = Get-AzRecoveryServicesAsrJob -Job $networkmappingASRJob
}

#Check if the Job completed successfully. The updated job state of a successfully completed job should be "Succeeded"
Write-Output $networkmappingASRJob.State

#Specify replication properties for each disk of the VM that is to be replicated (create disk replication configuration)

#OsDisk
$OSdiskId = $vm.StorageProfile.OsDisk.ManagedDisk.Id
$RecoveryOSDiskAccountType = $vm.StorageProfile.OsDisk.ManagedDisk.StorageAccountType
$RecoveryReplicaDiskAccountType = $vm.StorageProfile.OsDisk.ManagedDisk.StorageAccountType

$OSDiskReplicationConfig = New-AzRecoveryServicesAsrAzureToAzureDiskReplicationConfig -ManagedDisk -LogStorageAccountId $CacheStorageAccount.Id `
         -DiskId $OSdiskId -RecoveryResourceGroupId  $SourceRG.ResourceId -RecoveryReplicaDiskAccountType  $RecoveryReplicaDiskAccountType `
         -RecoveryTargetDiskAccountType $RecoveryOSDiskAccountType

# Data disk
$DataDiskCheck = $vm.StorageProfile.DataDisks
IF ($DataDiskCheck -ne $Null){
$datadiskId1 = $vm.StorageProfile.DataDisks[0].ManagedDisk.Id
$RecoveryReplicaDiskAccountType = $vm.StorageProfile.DataDisks[0].ManagedDisk.StorageAccountType
$RecoveryTargetDiskAccountType = $vm.StorageProfile.DataDisks[0].ManagedDisk.StorageAccountType

$DataDisk1ReplicationConfig  = New-AzRecoveryServicesAsrAzureToAzureDiskReplicationConfig -ManagedDisk -LogStorageAccountId $CacheStorageAccount.Id `
         -DiskId $datadiskId1 -RecoveryResourceGroupId $SourceRG.ResourceId -RecoveryReplicaDiskAccountType $RecoveryReplicaDiskAccountType `
         -RecoveryTargetDiskAccountType $RecoveryTargetDiskAccountType


#Create a list of disk replication configuration objects for the disks of the virtual machine that are to be replicated.
$diskconfigs = @()
$diskconfigs += $OSDiskReplicationConfig, $DataDisk1ReplicationConfig
}
ELSE {
$diskconfigs = @()
$diskconfigs += $OSDiskReplicationConfig
}

#Start replication by creating replication protected item. Using a GUID for the name of the replication protected item to ensure uniqueness of name.
$protecteditemcheck = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $PrimaryProtContainer -ErrorAction 0
IF ($protecteditemcheck -eq $null) {New-AzRecoveryServicesAsrReplicationProtectedItem -AzureToAzure -AzureVmId $VM.Id -Name (New-Guid).Guid -ProtectionContainerMapping $EusToWusPCMapping -AzureToAzureDiskReplicationConfiguration $diskconfigs -RecoveryResourceGroupId $SourceRG.ResourceId}