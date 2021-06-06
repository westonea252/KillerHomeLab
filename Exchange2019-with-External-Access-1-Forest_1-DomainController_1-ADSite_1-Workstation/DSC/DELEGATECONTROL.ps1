configuration DELEGATECONTROL
{
   param
   (
        [String]$NetBiosDomain,
        [String]$DomainName,        
        [String]$BaseDN,
        [String]$ServiceAccount,        
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module ActiveDirectoryDsc

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        ADUser ServiceAccount
        {
            Ensure     = 'Present'            
            UserName   = $ServiceAccount
            DomainName = $DomainName
            Path       = "OU=Service,OU=Accounts,$BaseDN"
            Password = $DomainCreds
            Enabled = $True
        }

        Script DelegateServiceAccount
        {
            SetScript =
            {
                # Import AD Module
                Import-Module ActiveDirectory

                # Load Default ACL for AD Domain
                $acl = Get-Acl -Path 'ad:$using:BaseDN'

                # Load AD Configuration
                $rootdse = Get-ADRootDSE

                # Load Service Account
                $ServiceAccountID = New-Object System.Security.Principal.SecurityIdentifier (Get-ADUser "$using:ServiceAccount").SID

                # Create GUID Map
                $guidmap = @{}
                Get-ADObject -SearchBase ($rootdse.SchemaNamingContext) -LDAPFilter "(schemaidguid=*)" -Properties lDAPDisplayName,schemaIDGUID | % {$guidmap[$_.lDAPDisplayName]=[System.GUID]$_.schemaIDGUID}

                # Create ACE Entries

                $CityACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["l"],"Descendents",$guidmap["user"]
                $DepartmentACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["department"],"Descendents",$guidmap["user"]
                $EmployeeTypeACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["employeetype"],"Descendents",$guidmap["user"]
                $TitleACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["title"],"Descendents",$guidmap["user"]
                $MobileACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["mobile"],"Descendents",$guidmap["user"]
                $OfficeLocationACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["physicaldeliveryofficename"],"Descendents",$guidmap["user"]
                $StateACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["st"],"Descendents",$guidmap["user"]
                $StreetAddressACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["streetaddress"],"Descendents",$guidmap["user"]
                $TelephoneNumberACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["telephonenumber"],"Descendents",$guidmap["user"]
                $ZipCodeACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ServiceAccountID,"WriteProperty,ReadProperty","Allow",$guidmap["postalcode"],"Descendents",$guidmap["user"]

                # Add ACE Entries to existing AD ACL
                $Acl.AddAccessRule($CityACE)
                $Acl.AddAccessRule($DepartmentACE)
                $Acl.AddAccessRule($EmployeeTypeACE)
                $Acl.AddAccessRule($TitleACE)
                $Acl.AddAccessRule($MobileACE)
                $Acl.AddAccessRule($OfficeLocationACE)
                $Acl.AddAccessRule($StateACE)
                $Acl.AddAccessRule($StreetAddressACE)
                $Acl.AddAccessRule($TelephoneNumberACE)
                $Acl.AddAccessRule($ZipCodeACE)

                # Save AD ACL
                Set-Acl -AclObject $Acl -Path 'ad:$using:BaseDN'
                
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[ADUser]ServiceAccount'
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