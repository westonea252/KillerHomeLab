configuration EXCHANGE16
{
   param
   (
        [String]$NetBiosDomain,
        [String]$DBName,
        [String]$SetupDC,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        File ExchangeInstall
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall'
            Ensure = "Present"
        }

        Script InstallExchange2016
        {
            SetScript =
            {
                Set-Content -Path S:\ExchangeInstall\DeployExchange.cmd -Value "J:\Setup.exe /Iacceptexchangeserverlicenseterms /Mode:Install /Role:Mailbox /DbFilePath:M:\$using:DBName\$using:DBName.edb /LogFolderPath:M:\$using:DBName /MdbName:$using:DBName /dc:$using:SetupDC"
                S:\ExchangeInstall\DeployExchange.cmd
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }

    }
}