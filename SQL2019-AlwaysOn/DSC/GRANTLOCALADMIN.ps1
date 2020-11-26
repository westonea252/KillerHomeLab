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
                Add-LocalGroupMember -Member "$NetBiosDomain\$Account" -Group Administrators
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}