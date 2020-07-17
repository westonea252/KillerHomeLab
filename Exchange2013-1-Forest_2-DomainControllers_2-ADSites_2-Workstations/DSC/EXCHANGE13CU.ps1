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

        Script ExtractExchangeCU
        {
            SetScript =
            {
                # Create Exchange Extraction
                Set-Content -Path C:\MachineConfig\ExtractExchange.cmd -Value "S:\ExchangeInstall\Exchange.exe /extract:S:\ExchangeInstall\ExchangeCU /q"
                C:\MachineConfig\ExtractExchange.cmd
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]DownloadExchangeCU'
        }

        File ExchangeCU
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall\ExchangeCU'
            Ensure = "Present"
            DependsOn = '[Script]ExtractExchangeCU'
        }

        Script InstallExchangeCU
        {
            SetScript =
            {
                Set-Content -Path S:\ExchangeInstall\DeployExchangeCU.cmd -Value "S:\ExchangeInstall\Exchange2013CU\Setup.exe /Iacceptexchangeserverlicenseterms /Mode:Upgrade /dc:$using:SetupDC"
                S:\ExchangeInstall\DeployExchangeCU.cmd
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
            DependsOn = '[File]ExchangeCU'
        }

    }
}