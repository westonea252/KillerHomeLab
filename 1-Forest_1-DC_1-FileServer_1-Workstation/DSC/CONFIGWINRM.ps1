Configuration CONFIGWINRM
{
   param
   (
        [String]$MaxEnvelopeSizeinKB
    )

    Node LocalHost
    {

        Script UpdateWinRMSettings
        {
            SetScript =
            {
                # Set WinRM MaxEnvelopeSize
                Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value $using:MaxEnvelopeSizeinKB
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}