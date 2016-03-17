#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

$SiteCode = "TAB"

$PackageID = "TAB00004"

$nalpath = '["Display=\\1ndcitvwmp01.tsi.lan\"]MSWNET:["SMS_SITE=TSP"]\\tri-sccmsql.twi.dom\'

$distpoint = Get-WmiObject -class SMS_DistributionPoint -namespace "root\SMS\Site_$($SiteCode)" | Where-Object{$_.PackageID -match "$PackageID"}


foreach($dp in $distpoint)
{

    If($nalpath -eq $dp.ServerNalPath)
    {
    $dp.RefreshNow = $true
    $dp.Put()
    
    }
}