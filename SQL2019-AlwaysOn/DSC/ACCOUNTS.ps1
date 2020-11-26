configuration ACCOUNTS
{
   param
   (
        [String]$DomainName,        
        [String]$BaseDN,
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module ActiveDirectoryDsc

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        ADUser Install
        {
            Ensure     = 'Present'
            UserName   = "Install"
            DomainName = $DomainName
            Path       = "OU=Office 365,OU=End User,OU=Accounts,$BaseDN"
            Password = $DomainCreds
            Enabled = $True
        }

        ADUser SQLSvc1
        {
            Ensure     = 'Present'            
            UserName   = "SQLSvc1"
            DomainName = $DomainName
            Path       = "OU=Office 365,OU=End User,OU=Accounts,$BaseDN"
            Password = $DomainCreds
            Enabled = $True
        }

        ADUser SQLSvc2
        {
            Ensure     = 'Present'            
            UserName   = "SQLSvc2"
            DomainName = $DomainName
            Path       = "OU=Office 365,OU=End User,OU=Accounts,$BaseDN"
            Password = $DomainCreds
            Enabled = $True
        }
    }
}

$configData = @{
                AllNodes = @(
                              @{
                                 NodeName = 'localhost';
                                 PSDscAllowPlainTextPassword = $true
                                    }
                    )
               }