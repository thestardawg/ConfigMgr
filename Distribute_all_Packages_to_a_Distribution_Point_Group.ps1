$SiteServer = "1ndcitvwcm01.tsi.lan"
$SiteCode = "TAB"
$DistributionGroup = "Data Centers"

$ModulePath = (($env:SMS_ADMIN_UI_PATH).Substring(0,$env:SMS_ADMIN_UI_PATH.Length-5)) + '\ConfigurationManager.psd1'
Import-Module $ModulePath -Force
if ((Get-PSDrive $SiteCode -ErrorAction SilentlyContinue | Measure-Object).Count -ne 1) {
    New-PSDrive -Name $SiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root $SiteServer
}
$SiteDrive = $SiteCode + ":"
Set-Location $SiteDrive

$Packages = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_Package -ComputerName $SiteServer
$Packages | ForEach-Object {
    $PackageName = $_.Name
    Write-Output "Starting distribution of: $($PackageName)"
    Start-CMContentDistribution -PackageName $PackageName -DistributionPointGroupName $DistributionGroup | Out-Null
}

Set-Location C: