Configuration CREATESHARE
{
   param
   (
        [String]$NamingConvention,     
        [String]$NetBiosDomain,
        [String]$InternalDomainName
    )

    Import-DscResource -Module xStorage
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    Node $AllNodes.NodeName

{
        File CreateShareFolder
        {
            Type = 'Directory'
            DestinationPath = "C:\Parent\Child"
            Ensure = "Present"
        }

        Script ConfigureSharePermissions
        {
            SetScript =
            {
                # Create Parent Share
                $ChildShare = Get-SmbShare -Name "Child" -ErrorAction 0
                IF ($ChildShare -eq $Null) {
                New-SmbShare -Name "Child" -Path "C:\Parent\Child" -ReadAccess "Everyone"
                
                # Disable Inheritance & Remove Existing Permissions
                $acl = Get-ACL -Path "C:\Parent\Child"
                $acl.SetAccessRuleProtection($True, $False)
                $acl.Access | %{$acl.RemoveAccessRule($_)}
                Set-Acl -Path "C:\Parent\Child" -AclObject $acl

                # Grant Service ACcount
                $permission="$using:ServiceAccount","ReadandExecute","Allow"
                $accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
                $acl.AddAccessRule($accessRule)
                Set-Acl -Path "C:\Parent\Child" -AclObject $acl

                # Grant Local Administrators
                $user = 'Administrators'          
                $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
                $AccessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
                $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
                $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"None"
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
                $acl.AddAccessRule($AccessRule)
                Set-Acl -Path "C:\Parent\Child" -AclObject $acl

                # Grant SYSTEM
                $user = 'SYSTEM'          
                $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
                $AccessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
                $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
                $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"None"
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
                $acl.AddAccessRule($AccessRule)
                Set-Acl -Path "C:\Parent\Child" -AclObject $acl
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]CreateShareFolder'
        }

        Script CreateDataFile
        {
            SetScript =
            {
                $quote = '"'
                $UserID1 = "$quote$using:NamingConvention"+'-user1'+$quote
                $UserID2 = "$quote$using:NamingConvention"+'-user2'+$quote                
                $UserID3 = "$quote$using:NamingConvention"+'-user3'+$quote
                $EmployeeName1 = "$quote"+'User1, '+"$using:NamingConvention"+$quote
                $EmployeeName2 = "$quote"+'User2, '+"$using:NamingConvention"+$quote
                $EmployeeName3 = "$quote"+'User3, '+"$using:NamingConvention"+$quote
                $StaffID1 = "1111"
                $StaffID2 = "2222"
                $StaffID3 = "3333"
                $Email1 = "$quote$using:NamingConvention"+'-user1@'+"$using:InternalDomainName"+$quote
                $Email2 = "$quote$using:NamingConvention"+'-user2@'+"$using:InternalDomainName"+$quote
                $Email3 = "$quote$using:NamingConvention"+'-user3@'+"$using:InternalDomainName"+$quote
                $Section = "$quote"+'IT'+"$quote"
                $EmployeeType = "$quote"+'CTR'+"$quote"
                $CellPhone1 = "$quote"+'111-111-1111'+"$quote"
                $CellPhone2 = "$quote"+'111-222-1111'+"$quote"
                $CellPhone3 = "$quote"+'111-333-1111'+"$quote"
                $OfficePhone1 = "$quote"+'111-111-1112'+"$quote"
                $OfficePhone2 = "$quote"+'111-222-1112'+"$quote"
                $OfficePhone3 = "$quote"+'111-333-1112'+"$quote"
                $OfficeName1 = "$quote"+'Room1'+"$quote"
                $OfficeName2 = "$quote"+'Room2'+"$quote"
                $OfficeName3 = "$quote"+'Room3'+"$quote"
                $Building1 = "$quote"+'MSFT BLD1'+"$quote"
                $Building2 = "$quote"+'MSFT BLD2'+"$quote"
                $Building3 = "$quote"+'MSFT BLD3'+"$quote"
                $Street1 = "$quote"+'111 Street'+"$quote"
                $Street2 = "$quote"+'222 Street'+"$quote"
                $Street3 = "$quote"+'333 Street'+"$quote"
                $City1 = "$quote"+'Lithia'+"$quote"
                $City2 = "$quote"+'Alexandria'+"$quote"
                $City3 = "$quote"+'Lexington Park'+"$quote"
                $State1 = "$quote"+'Florida'+"$quote"
                $State2 = "$quote"+'Virginia'+"$quote"
                $State3 = "$quote"+'Maryland'+"$quote"       
                $Zip1 = "$quote"+'33547'+"$quote"
                $Zip2 = "$quote"+'22309'+"$quote"
                $Zip3 = "$quote"+'20653'+"$quote"
                $Title1 = "$quote"+'Customer Engineer'+"$quote"
                $Title2 = "$quote"+'Cloud Solution Architect'+"$quote"
                
                # Create File
                $file = Get-Item -Path "C:\Parent\Child\Child.txt" -ErrorAction 0
                IF ($file -eq $Null){
                Set-Content -Path C:\Parent\Child\Child.txt -Value '"User ID","Employee Name","StaffID","Email","Section","Employee Type","Wireless","Office Phone","PhysicalDeliveryOfficeName","Office","Building","StreetAddress","City","State","Zip Code","Title"'
                Add-Content -Path C:\Parent\Child\Child.txt -Value "$UserID1,$EmployeeName1,$StaffID1,$Email1,$EmployeeType,$CellPhone1,$OfficePhone1,$OfficeName1,$OfficeName1,$Building1,$Street1,$City1,$State1,$Zip1,$Title1"
                Add-Content -Path C:\Parent\Child\Child.txt -Value "$UserID2,$EmployeeName2,$StaffID2,$Email2,$EmployeeType,$CellPhone2,$OfficePhone2,$OfficeName2,$OfficeName2,$Building2,$Street2,$City2,$State2,$Zip2,$Title2"
                Add-Content -Path C:\Parent\Child\Child.txt -Value "$UserID3,$EmployeeName3,$StaffID3,$Email1,$EmployeeType,$CellPhone3,$OfficePhone3,$OfficeName3,$OfficeName3,$Building3,$Street3,$City3,$State3,$Zip3,$Title3"

                # Compress File
                Compress-Archive -Path C:\Parent\Child\Child.txt -DestinationPath C:\Parent\Child\Child.zip
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]ConfigureSharePermissions'
        }
    }
}