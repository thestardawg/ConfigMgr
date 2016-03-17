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

$i = 0
$DPGroupArray = @()
$AppsToDistribute = @()

$DPGroupStatus = Get-WmiObject -ComputerName $SiteServer -Namespace root\SMS\site_$SiteCode -class SMS_DPGroupDistributionStatusDetails -Filter "ObjectType = 512 AND MessageState = 1 OR MessageState = 2" | Select-Object ObjectID
$DPGroupStatus | ForEach-Object {
    $i++
    $ObjectID = $_.ObjectID
    Write-Progress -id 1 -Activity "Getting Status Messages from Distribution Point Group" -Status "Adding object $($i) of $($DPGroupStatus.Count) to array" -PercentComplete (($i / $DPGroupStatus.Count)*100)
    $DPGroupArray += $ObjectID
}

$Applications = Get-WmiObject -ComputerName $SiteServer -Namespace root\SMS\site_$SiteCode -class SMS_Application | Where-Object {$_.IsLatest -eq $True} 
$Applications | ForEach-Object {
    $AppName = $_.LocalizedDisplayName
    $ModelName = $_.ModelName
    if ($DPGroupArray -notcontains $ModelName ) {
        $AppsToDistribute += $ModelName
    }
}

if ($AppsToDistribute.Count -ge 1) {
    Write-Output "Found a total of $($AppsToDistribute.Count) Applications to distribute:`n"
    $AppsToDistribute | ForEach-Object {
        $ID = $_
        $CurrentAppName = (Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_Application -ComputerName $SiteServer | Where-Object { $_.ModelName -like "$($ID)" }).LocalizedDisplayName
        Write-Output "Distributing: $($CurrentAppName)"
        Start-CMContentDistribution -ApplicationName $CurrentAppName -DistributionPointGroupName $DistributionGroup | Out-Null
    }
}
else {
    Write-Output "Distribution Point Group: $($DistributionGroup)"
    Write-Output "Results: No undistributed Applications found"
}

Set-Location C:
