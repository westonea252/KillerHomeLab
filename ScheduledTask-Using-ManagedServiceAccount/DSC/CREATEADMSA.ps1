configuration CREATEADMSA
{
   param
   (
        [String]$NetBiosDomain,
        [String]$domainName,
        [String]$computerName,
        [String]$ServiceAccount
    )

    Node localhost
    {
        Script IssueCARequest
        {
            SetScript =
            {
                # Create KDS Root Key
                $rootkey = Get-KdsRootKey
                IF ($rootkey -eq $nullvar){Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)}
     
                # Create AD Managed Service Account
                $gmsa = Get-ADServiceAccount -Filter * | Where-Object {$_.Name -like "$using:ServiceACcount"}
                IF ($gmsa -eq $nullvar){New-ADServiceAccount "$using:ServiceACcount" -DNSHostName "$using:computerName.$using:domainName"}

            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}