#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

$failures = $null

# Find all content with State = 1, State = 2 or State = 3, see http://msdn.microsoft.com/en-us/library/cc143014.aspx
$failures = Get-WmiObject -Namespace root\sms\site_$SiteCode -Query "SELECT * FROM SMS_PackageStatusDistPointsSummarizer WHERE State = 1 or State = 2 Or state = 3 Or state = 8"


if ($failures -eq $null)
    {
    	"No failed content distribution."
    }
else
    {
        foreach ($failure in $failures)
            {
                # Get the distribution points that content wouldn't distribute to
		$DistributionPoints = Get-WmiObject -Namespace root\sms\site_$SiteCode -Query "SELECT * FROM SMS_DistributionPoint WHERE SiteCode='$($failure.SiteCode)' AND PackageID='$($failure.PackageID)'"
                foreach ($DistributionPoint in $DistributionPoints)
                    {
                        #check if we are really looking at the correct Distribution Point
			if ($DistributionPoint.ServerNALPath -eq $failure.ServerNALPath)
                            {
                                # Use the RefreshNow Property to "Refresh Distribution Point", see http://msdn.microsoft.com/en-us/library/hh949735.aspx
				$DistributionPoint.RefreshNow = $true
                                $DistributionPoint.put()
                               
                            }
                    
                    }
            }
    }                    
