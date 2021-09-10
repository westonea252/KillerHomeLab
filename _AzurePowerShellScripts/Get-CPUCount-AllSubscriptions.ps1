$Family = Read-Host "Please Enter the Family Sku Name"
$Exclude = Read-Host "Please Enter Family Exlusion"
$CombinedView = @()

# Select Subscription
$Subscriptions = Get-AzSubscription -ErrorAction 0
foreach ($Subscription in $Subscriptions){
Select-AzSubscription -Subscription $Subscription.Name
$SubscriptionName = $Subscription.Name
$AllVMsInSub = Get-azvm -ErrorAction 0 | Where-Object {$_.HardwareProfile.VmSize -like '*'+$Family+'*' -and $_.HardwareProfile.VmSize -notlike '*'+$Exclude+'*'}

$Locations = Get-AzLocation -ErrorAction 0
    foreach ($Location in $Locations){
    $TotalCPUCount = @()

    # Get All VM's with specific Family Type
    $LocationName = $Location.Location
    $VMs = $AllVMsInSub | Where-Object {$_.Location -like $LocationName}
        foreach ($VM in $VMs ){
        $VMSize = (Get-AzVM -Name $VM.Name).HardwareProfile.VmSize
        $VMCoreCount = (Get-AzVMSize -VMName $VM.Name -ResourceGroupName $vm.ResourceGroupName -ErrorAction 0 | Where-Object {$_.Name -like $VMSize}).NumberOfCores

        $TotalCPUCount += $VMCoreCount

        $CombinedCPUCount = $TotalCPUCount | Measure-Object -Sum

        $obj = new-object psobject -InformationAction SilentlyContinue -Property @{
            "Total $SubscriptionName $LocationName $Family CPU Count" = $CombinedCPUCount.Sum
                            }
        }
        $CombinedView += $obj | Format-List "Total $SubscriptionName $LocationName $Family CPU Count"
}
}
# Clean Up View/Remove File
$CombinedView | Out-File "C:\Temp\CPUCount.txt"
$file = "C:\Temp\CPUCount.txt"
$file = Get-Content -Path "C:\Temp\CPUCount.txt"
$file | ForEach-Object {$_.TrimEnd()} | Where-Object {$_.trim()}
Remove-Item -Path C:\Temp\CPUCount.txt -Force