$SiteCode = ""
$PackageID = ""
     $distpoints = Get-WmiObject -Namespace "root\SMS\Site_$($SiteCode)" -Query "Select * From SMS_DistributionPoint WHERE PackageID='$PackageID'"
        foreach ($dp in $distpoints)
        {
                $dp.RefreshNow = $true
                $dp.Put()
        }
