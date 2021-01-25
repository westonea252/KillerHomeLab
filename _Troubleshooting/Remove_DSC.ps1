$vm = Read-Host "Enter VM Name"
$Session = New-CimSession -ComputerName $vm
Remove-DscConfigurationDocument -Stage Previous -CimSession $Session
Remove-DscConfigurationDocument -Stage Current -CimSession $Session
Remove-DscConfigurationDocument -Stage Pending -CimSession $Session