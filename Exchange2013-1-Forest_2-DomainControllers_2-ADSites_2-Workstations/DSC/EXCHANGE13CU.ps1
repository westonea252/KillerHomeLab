configuration EXCHANGE13CU
{
   param
   (
        [String]$ExchangeCUSASUrl,             
        [String]$NetBiosDomain,
        [String]$SetupDC,
        [System.Management.Automation.PSCredential]$Admincreds
    )
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        xRemoteFile DownloadExchangeCU
        {
            DestinationPath = "S:\ExchangeInstall\Exchange.exe"
            Uri             = "$ExchangeCUSASUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
        }

        File ExchangeCU
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall\ExchangeCU'
            Ensure = "Present"
            DependsOn = '[xRemoteFile]DownloadExchangeCU'
        }

        Script InstallExchangeCU
        {
            SetScript =
            {
                $Install = Get-ChildItem -Path S:\ExchangeInstall\DeployExchangeCU.cmd -ErrorAction 0
                IF ($Install -eq $null) {                
                Set-Content -Path S:\ExchangeInstall\DeployExchangeCU.cmd -Value "S:\ExchangeInstall\Exchange.exe /extract:S:\ExchangeInstall\ExchangeCU /q"
                Add-Content -Path S:\ExchangeInstall\DeployExchangeCU.cmd -Value "S:\ExchangeInstall\ExchangeCU\Setup.exe /Iacceptexchangeserverlicenseterms /Mode:Upgrade /dc:$using:SetupDC"
                S:\ExchangeInstall\DeployExchangeCU.cmd
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }

    }
}