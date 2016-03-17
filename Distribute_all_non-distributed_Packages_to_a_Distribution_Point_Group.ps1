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

$PackageIDs = @()
$PackagesToDistribute = @()

$DPGroupPackages = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_DPGroupPackages -ComputerName $SiteServer
$DPGroupPackages | ForEach-Object {
    $DPGroupPackageID = $_.PkgID
    $PackageIDs += $DPGroupPackageID
}

$Packages = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_Package -ComputerName $SiteServer
$Packages | ForEach-Object {
    $PackageID = $_.PackageID
    $PackageName = $_.Name
    if ($PackageIDs -notcontains $PackageID ) {
        $PackagesToDistribute += $PackageID        
    }
}

if ($PackagesToDistribute.Count -ge 1) {
    Write-Output "Found a total of $($PackagesToDistribute.Count) Packages to distribute:`n"
    $PackagesToDistribute | ForEach-Object {
        $ID = $_
        $CurrentPackageName = (Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_Package -ComputerName $SiteServer | Where-Object { $_.PackageID -like "$($ID)" }).Name
        Write-Output "Distributing: $($CurrentPackageName)"
        Start-CMContentDistribution -PackageName $CurrentPackageName -DistributionPointGroupName $DistributionGroup | Out-Null
    }
}
else {
    Write-Output "Distribution Point Group: $($DistributionGroup)"
    Write-Output "Results: No undistributed Packages found"
}

Set-Location C: