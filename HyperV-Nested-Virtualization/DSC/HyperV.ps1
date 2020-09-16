Configuration HyperV
{
   param
   (
        [String]$HyperVNATIP,
        [String]$HyperVSubnetPrefix
    )
 
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xStorage # Used for ISO
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemote

    Node localhost
    {
        WindowsFeature 'Hyper-V'
        {
            Name   = 'Hyper-V'
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }

        xWaitforDisk Disk2
        {
             DiskId = 2
             RetryIntervalSec = 60
             RetryCount = 60
        }

        xDisk VVolume
        {
             DiskId = 2
             DriveLetter = 'V'
             DependsOn = '[xWaitForDisk]Disk2'
        }
        
        xWaitforVolume WaitForvVolume
        {
             DriveLetter = 'V'
             RetryIntervalSec = 60
             RetryCount = 60
        }

        Script ConfigureHyperV
        {
            SetScript =
            {
                # CREATE Hyper-V Switch
                $SwitchCheck = Get-VMSwitch -Name "InternalNAT"
                IF ($SwitchCheck -eq $null) {New-VMSwitch -Name "InternalNAT" -SwitchType Internal}

                # Get IfIndex
                $Adapter = Get-NetAdapter | Where-Object {$_.Name -like '*InternalNAT*'}
                
                #  Create NAT Gateway
                New-NetIPAddress -IPAddress $HyperVNATIP -PrefixLength 24 -InterfaceAlias $Adapter.ifIndex

                # Create NAT Network
                New-NetNat -Name "InternalNat" -InternalIPInterfaceAddressPrefix $HyperVSubnetPrefix
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xWaitForVolume]WaitForVVolume'
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }
     }
  }