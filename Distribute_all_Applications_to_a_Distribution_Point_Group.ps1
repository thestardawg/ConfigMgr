$SiteServer = "cm01"
$SiteCode = ""
$DistributionGroup = "Data Centers"

$ModulePath = (($env:SMS_ADMIN_UI_PATH).Substring(0,$env:SMS_ADMIN_UI_PATH.Length-5)) + '\ConfigurationManager.psd1'
Import-Module $ModulePath -Force
if ((Get-PSDrive $SiteCode -ErrorAction SilentlyContinue | Measure-Object).Count -ne 1) {
    New-PSDrive -Name $SiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root $SiteServer
}
$SiteDrive = $SiteCode + ":"
Set-Location $SiteDrive

$Applications = Get-WmiObject -ComputerName $SiteServer -Namespace root\SMS\site_$SiteCode -class SMS_Application | Where-Object {$_.IsLatest -eq $True} 
$Applications | ForEach-Object {
    $AppName = $_.LocalizedDisplayName
    Write-Output "Starting distribution of: $($AppName)"
    Start-CMContentDistribution -ApplicationName $AppName -DistributionPointGroupName $DistributionGroup  | Out-Null
}

Set-Location C:
