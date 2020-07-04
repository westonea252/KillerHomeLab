configuration RESTARTVM
{
   param
   (
    )

    Node localhost
    {
        Script RestartVM
        {
            SetScript =
            {
                # Restart VM
                Restart-Computer -Force

            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}