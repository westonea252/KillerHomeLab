# Set Source Variables

# Select Subscription
$Subscriptions = Get-AzSubscription | Select-Object Name, ID
$Subscription = $Subscriptions | Out-GridView -PassThru

# Write-Host "Example: USGov Virginia"
# $dstlocation = Read-Host "Please enter Restore Location for the VM Restore"
$rstlocation = 'USGov Virginia'

# Write-Host "Example: USGov Texas"
# $dstlocation = Read-Host "Please enter Destination Location for the VM Restore"
$dstlocation = 'USGov Texas'

# Write-Host "Example:  ASR-Test-GovTX"
# $dstVMRG = Read-Host "Please enter VM's Destination Resource Group"
$dstVMRG = 'ASR-Test-GovTX'

# Select VM
# Write-Host "Example:  khl-srv-01"
# $vmName = Read-Host "Please enter VM Name"
$vmName = 'khl-srv-01'

# Write-Host "Example:  ASR-Test-GovTX-VNet1"
# $dstvNetName = Read-Host "Please enter VM's Destination Virtual Network Name"
$dstvNetName = 'ASR-Test-GovTX-VNet1'

# Write-Host "Example:  ASR-Test-GovTX"
# $dstvNetNameRG = Read-Host "Please enter VM's Destination Virtual Network Resource Group Name"
$dstvNetNameRG = 'ASR-Test-GovTX'

# Write-Host "Example: khl-rv1-1234567890x36"
# $RSVault = Read-Host "Please enter Recovery Services Vault Name"
$RSVault = 'khl-rv1-1234567890x36'

# Write-Host "Example: vabackuptest"
# $rstStorageAccountName =  Read-Host "Please enter Restore Storage Account Name"
$rstStorageAccountName = 'vabackuptest'

# Write-Host "Example: ASR-Test-GovVA"
# $rstStorageAccountNameRG =  Read-Host "Please enter Restore Storage Account Resource Group Name"
$rstStorageAccountNameRG = 'ASR-Test-GovVA'

# Write-Host "Example: txbackuptest"
# $dstStorageAccountName =  Read-Host "Please enter Destination Storage Account Name"
$dstStorageAccountName = 'txbackuptest'

# Write-Host "Example: ASR-Test-GovTX"
# $dstStorageAccountNameRG =  Read-Host "Please enter Destination Storage Account Resource Group Name"
$dstStorageAccountNameRG = 'ASR-Test-GovTX'

# Write-Host "Example: vmmigration"
# $dstCN = Read-Host "Please enter Destination Storage Account Container Name"
$dstCN = 'vmmigration'

# Write-Host "Example: C:\JSONs"
# $jsonfileroot = Read-Host "Please enter the root location of the JSONFile used for VM Configuration"
$jsonfileroot = 'C:\JSONs\'
$checkjsonfileroot = Get-Item -Path $jsonfileroot -ErrorAction 0
IF ($checkjsonfileroot -eq $null) {New-Item -ItemType Directory -Path $jsonfileroot -Force}
$jsonfile = $jsonfileroot+$vmName+'-Config.json'

# Write-Host "Last Recovery Point      = 0)"
# Write-Host "2 Day Old Recovery Point = 1)"
# Write-Host "3 Day Old Recovery Point = 2)"
# $rpdays = Read-Host "Last Recovery Point in Days"
$rpdays = 0

$Date = (Get-Date)
$DateStr = $Date.ToString("yyyyMMddmmss")
$storageType = "Standard_LRS"

# Set Source Storage Context
# Create Restore Storage Account
New-AzStorageAccount -ResourceGroupName $rstStorageAccountNameRG -Name $rstStorageAccountName -Location $rstlocation -SkuName $storageType -Kind StorageV2
$rstStorageAccountNameKey = Get-AzStorageAccountKey -ResourceGroupName $rstStorageAccountNameRG -StorageAccountName $rstStorageAccountName
$rstContext = New-AzStorageContext -StorageAccountName $rstStorageAccountName -StorageAccountKey $rstStorageAccountNameKey.Value[0]
Set-AzCurrentStorageAccount -StorageAccountName $rstStorageAccountName -ResourceGroupName $rstStorageAccountNameRG

# Azure Restore
Get-AzRecoveryServicesVault -Name $RSVault | Set-AzRecoveryServicesVaultContext
$namedContainer = Get-AzRecoveryServicesBackupContainer  -ContainerType "AzureVM" -Status "Registered" | Where-Object {$_.FriendlyName -like $vmName+'*'}
$backupitem = Get-AzRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
$startDate = (Get-Date).AddDays(-7)
$endDate = Get-Date
$rp = Get-AzRecoveryServicesBackupRecoveryPoint -Item $backupitem -StartDate $startdate.ToUniversalTime() -EndDate $enddate.ToUniversalTime()
$restorejob = Restore-AzRecoveryServicesBackupItem -RecoveryPoint $rp[0] -StorageAccountName $rstStorageAccountName -StorageAccountResourceGroupName $rstStorageAccountNameRG  -RestoreAsUnmanagedDisks

while (($RestoreJob.Status -eq 'InProgress')){
$RestoreJob = Get-AzRecoveryServicesBackupJob -Job $RestoreJob
sleep 60}

# Gather Restore Job Details
$restorejob = Get-AzRecoveryServicesBackupJob -Job $restorejob
$details = Get-AzRecoveryServicesBackupJobDetails -Job $restorejob
$properties = $details.properties
$srcCN = $properties["Config Blob Container Name"]
$blobName = $properties["Config Blob Name"]

# Create JSON
$destination_path = $jsonfile
Get-AzStorageBlobContent -Container $srcCN -Blob $blobName -Destination $destination_path -Force
$obj = ((Get-Content -Path $destination_path -Raw -Encoding Unicode)).TrimEnd([char]0x00) | ConvertFrom-Json
$Blob0 = $obj.'properties.StorageProfile'.osDisk.vhd.uri.Split("/")[4]

# Set Destination Variables
$dstVNet = Get-AzVirtualNetwork -Name $dstvNetName -ResourceGroupName $dstvNetNameRG

# Create Destination Storage Account
New-AzStorageAccount -ResourceGroupName $dstStorageAccountNameRG -Name $dstStorageAccountName -Location $dstlocation -SkuName $storageType -Kind StorageV2

# Set Destination Storage Context
$dstStorageAccountNameKey = Get-AzStorageAccountKey -ResourceGroupName $dstStorageAccountNameRG -StorageAccountName $dstStorageAccountName
$dstContext = New-AzStorageContext -StorageAccountName $dstStorageAccountName -StorageAccountKey $dstStorageAccountNameKey.Value[0]
Set-AzCurrentStorageAccount -StorageAccountName $dstStorageAccountName -ResourceGroupName $dstStorageAccountNameRG
"$dstCN" | New-AzStorageContainer -Permission Off

# Copy OS Disk
Start-AzStorageBlobCopy -SrcContainer $srcCN -DestContainer $dstCN -SrcBlob $Blob0 -DestBlob $Blob0 -Context $rstContext -DestContext $dstContext

# Copy Data Disks
foreach($dd in $obj.'properties.StorageProfile'.DataDisks)
  {
  Start-AzStorageBlobCopy -SrcContainer $srcCN -DestContainer $dstCN -SrcBlob $dd.vhd.Uri.Split("/")[4] -DestBlob $dd.vhd.Uri.Split("/")[4] -Context $rstContext -DestContext $dstContext
  }

# Wait for OS Disk to Finish Copying
Get-AzStorageBlobCopyState -Blob $Blob0 -Container $dstCN -WaitForComplete

# Wait for Data Disks to Finish Copying
foreach($dd in $obj.'properties.StorageProfile'.DataDisks)
  {
  Get-AzStorageBlobCopyState -Blob $dd.vhd.Uri.Split("/")[4] -Container $dstCN -WaitForComplete
  }

# Get Destination Storage Account
$dstStorageAccount = Get-AzStorageAccount -Name $dstStorageAccountName -ResourceGroupName $dstStorageAccountNameRG

# Set Destination VM Hardware Size
$vm = New-AzVMConfig -VMSize $obj.'properties.hardwareProfile'.vmSize -VMName $vmName

# Create OS Disk Name
$osDiskName = $vm.Name + "_osdisk_"+$DateStr

# Set OS Uri
$osVhdUri = "https://"+$dstStorageAccountName+".blob.core.usgovcloudapi.net/" +$dstCN+"/"+$Blob0

# Create OS Disk Config
$osdiskConfig = New-AzDiskConfig -AccountType $storageType -Location $dstlocation -CreateOption Import -SourceUri $osVhdUri -StorageAccountId $dstStorageAccount.Id

# Create OS Managed Disk
$osDisk = New-AzDisk -DiskName $osDiskName -Disk $osdiskConfig -ResourceGroupName $dstVMRG

# Attach OS Managed Disk
Set-AzVMOSDisk -VM $vm -ManagedDiskId $osDisk.Id -CreateOption "Attach" -Windows

# Create Data Managed Disks
foreach($dd in $obj.'properties.StorageProfile'.DataDisks)
  {
  $DataDiskvhdName = $dd.vhd.uri.Split("/")[4]
  $DataDiskName = $DataDiskvhdName.Split(".")[0]
  $DataVhdUri = "https://"+$dstStorageAccountName+".blob.core.usgovcloudapi.net/" +$dstCN+"/"+$dd.vhd.uri.Split("/")[4]
  $datadiskConfig = New-AzDiskConfig -AccountType $storageType -Location $dstlocation -CreateOption Import -SourceUri $DataVhdUri -StorageAccountId $dstStorageAccount.Id
  $DataDisk = New-AzDisk -DiskName $DataDiskName -Disk $datadiskConfig -ResourceGroupName $dstVMRG
  Add-AzVMDataDisk -VM $vm -ManagedDiskId $DataDisk.Id -CreateOption "Attach" -Lun $dd.lun -Caching None
  }

# Create NICs
foreach($nic in $obj.'properties.networkProfile'.networkInterfaces)
 {
 $OldNicID = $obj.'properties.networkProfile'.networkInterfaces.Id
 $NewNicName = $obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[8]
 $NewNicID = '/'+$obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[1]+'/'+$obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[2]+'/'+$obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[3]+'/'+$dstVMRG+'/'+$obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[5]+'/'+$obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[6]+'/'+$obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[7]+'/'+$obj.'properties.networkProfile'.networkInterfaces.Id.Split("/")[8]
 $isPrimary = $obj.'properties.networkProfile'.networkInterfaces.'properties.primary'
 New-AzNetworkInterface -ResourceGroupName $dstVMRG -Location $dstlocation -Name $NewNicName -SubnetId $dstVNet.Subnets[0].Id
     IF ($isPrimary -eq 'True'){
     $vm = Add-AzVMNetworkInterface -VM $vm -Id $NewNicID -Primary
     }
     ELSE {$vm = Add-AzVMNetworkInterface -VM $vm -Id $NewNicID}
 }

# Create VM
Set-AzVMBootDiagnostic -Disable -VM $vm
New-AzVM -ResourceGroupName $dstVMRG -Location $dstlocation -VM $vm

# Cleanup
# Remove Restore Storage Account
Remove-AzStorageAccount -ResourceGroupName $rstStorageAccountNameRG -Name $rstStorageAccountName -Force

# Remove Destination Storage Account
Remove-AzStorageAccount -ResourceGroupName $dstStorageAccountNameRG -Name $dstStorageAccountName -Force