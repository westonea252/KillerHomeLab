configuration RESTARTVM
{
   param
   (
    )

    Node localhost
    {
        File Machineconfig
        {
            Type = 'Directory'
            DestinationPath = 'C:\MachineConfig'
            Ensure = "Present"
        }

        Script RestartVM
        {
            SetScript =
            {
                # Restart VM
                $Path = Get-Item -Path C:\MachineConfig\RebootComplete.txt
                IF ($Path -eq $Null) {Restart-Computer -Force}

                Set-Content -Path C:\MachineConfig\RebootComplete.txt -Value "Complete"
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}