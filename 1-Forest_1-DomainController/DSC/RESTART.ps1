configuration RESTART
{
   param
   (
    )

    Import-DscResource -Module xPendingReboot

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        xPendingReboot RebootAfterPromotion{
            Name = "RebootAfterPromotion"
        }
    }
}