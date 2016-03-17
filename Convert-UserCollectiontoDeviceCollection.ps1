#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

$ErrorActionPreference= 'silentlycontinue'

#Convert List of Users to Device Collection
$list = Get-Content "E:\Old\Scripts\Scripts\SCCM\Convert User Collection To Device Collection\users.txt"
$deviceresourceids = $list | foreach {Get-CMUserDeviceAffinity -username $_ | select -ExpandProperty ResourceID}
$deviceresourceids | foreach {Add-CMDeviceCollectionDirectMembershipRule -CollectionName "ImportSanity" -ResourceId $_}