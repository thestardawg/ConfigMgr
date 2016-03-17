#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

$ErrorActionPreference= 'silentlycontinue'

#Collection must be pre-exist in SCCM.
$CollectionName = "Import 101"
#File must pre-exist in directory
$Computers = get-content "D:\ad\Scripts\SCCM\Add Device to Collection\import.txt"
Foreach ($Computer in $Computers)
{add-cmdevicecollectiondirectmembershiprule -collectionname $CollectionName -resourceid (Get-CMDevice -name $Computer).ResourceID}