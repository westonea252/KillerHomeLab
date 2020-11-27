configuration GRANTLOCALADMIN
{
   param
   (
        [String]$Account,
        [String]$NetBiosDomain
    )

    Node localhost
    {
        Script GrantLocalAdmin
        {
            SetScript =
            {
                $AccountCheck = Get-LocalGroupMember -Group Administrators -Member "$using:Account" -ErrorAction 0
                IF ($AccountCheck -eq $null){Add-LocalGroupMember -Member "$using:NetBiosDomain\$Using:Account" -Group Administrators}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}