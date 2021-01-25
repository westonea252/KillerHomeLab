configuration FW-ENABLEFILECOPY
{
    Node localhost
    {
        Script ConfigureADFS
        {
            SetScript =
            {
                # Enable Certificate Copy
                $EnableSMB = Get-NetFirewallRule "FPS-SMB-In-TCP" -ErrorAction 0
                IF ($EnableSMB -ne $null) {Enable-NetFirewallRule -Name "FPS-SMB-In-TCP"}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}