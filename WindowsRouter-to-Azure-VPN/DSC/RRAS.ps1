Configuration RRAS
{
    Node localhost
    {   
        WindowsFeature Routing
        { 
            Ensure = 'Present' 
            Name = 'Routing' 
        }         

        WindowsFeature RSAT-RemoteAccess
        { 
            Ensure = 'Present' 
            Name = 'RSAT-RemoteAccess' 
            DependsOn = '[WindowsFeature]Routing'
        }

        Script AllowLegacy
        {
            SetScript =
            {
                # Allow Remote Copy
                $allowlegacy = get-itemproperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters" -Name "ModernStackEnabled" -ErrorAction 0
                IF ($allowlegacy.ModernStackEnabled -ne 0) {New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RemoteAccess\Parameters\" -Name "ModernStackEnabled" -Value 0 -Force}
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[WindowsFeature]Routing'
        }
     }
  }