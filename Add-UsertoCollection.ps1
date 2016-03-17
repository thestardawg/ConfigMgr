#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

$ErrorActionPreference= 'silentlycontinue'
#Collection must pre-exist
$CollectionName = "Test"
#List of names must pre-exist
$Users = get-content "E:\Old\Scripts\Scripts\SCCM\Add User to Collection\users.txt"
Foreach ($User in $Users)
{Add-CMUserCollectionDirectMembershipRule -collectionname $CollectionName -resourceid (Get-CMUser -name $User).ResourceID}