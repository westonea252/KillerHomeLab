Configuration CABACKUP
{
   param
   (
        [String]$NetBiosDomain,   
        [String]$OCSPIP,   
        [String]$CAName,            
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        File CABackup
        {
            Type = 'Directory'
            DestinationPath = 'C:\CABACKUP'
            Ensure = "Present"
        }

        Script CABackup
        {
            SetScript =
            {
                # Backup CA Database and Private Key
                $DBBackupCheck = Get-ChildItem -Path "C:\CABackup\$using:CAName.log" -ErrorAction 0
                IF ($DBBackupCheck -eq $null) { 
                Backup-CARoleService –path C:\CABackup
                Stop-service CertSvc
                }

                # Backup CA Registry Settings
                $REGBackupCheck = Get-ChildItem -Path "C:\CABackup\$using:CAName.reg" -ErrorAction 0
                IF ($REGBackupCheck -eq $null) { 
                reg export HKLM\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration "C:\CABackup\$using:CAName.reg"
                Stop-service CertSvc
                }

                # Allow Remote Copy
                $winrmserviceitem = get-item -Path "HKLM:\Software\Policies\Microsoft\Windows\WinRm\Service" -ErrorAction 0
                $allowunencrypt = get-itemproperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WinRm\Service" -Name "AllowUnencryptedTraffic" -ErrorAction 0
                $allowbasic = get-itemproperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WinRm\Service" -Name "AllowBasic" -ErrorAction 0
                $firewall = Get-NetFirewallRule "FPS-SMB-In-TCP" -ErrorAction 0
                IF ($winrmserviceitem -eq $null) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WinRm\" -Name "Service" -Force}
                IF ($allowunencrypt -eq $null) {New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\" -Name "AllowUnencryptedTraffic" -Value 1}
                IF ($allowbasic -eq $null) {New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\" -Name "AllowBasic" -Value 1}
                IF ($firewall -ne $null) {Enable-NetFirewallRule -Name "FPS-SMB-In-TCP"}


            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]CABackup'
            PsDscRunAsCredential = $DomainCreds
        }

        File TransferCABackupToDC
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "C:\CABackup\"
            DestinationPath = "\\$OCSPIP\c$\CertEnroll"
            Credential = $Admincreds
            DependsOn = '[File]CABackup'
        }
     }
  }