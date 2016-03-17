#first part
$computer = $env:COMPUTERNAME
$pass = "NewPass09"
$user = "ITSupportAcct"
$newpass = [ADSI]"WinNT://$computer/$user,user"
$newpass.SetPassword($pass)
$newpass.SetInfo()
#second part encrpt input
param($key)
$key = @($key.split(","))
$raw = Get-content .\Encrypted.bin
$secure = ConvertTo-SecureString $raw -key $key
$helper = New-Object System.Management.Automation.PSCredential("Temp",$secure)
$plain = $helper.GetNetworkCredential().Password
Invoke-Expression $plain
#thirdpart decrypt
param($decrypted,$encrypted)
 
 $key = (1,0,5,9,56,34,254,211,4,4,2,23,42,54,33,200,1,34,2,7,6,9,35,37)
 $script = Get-Content $decrypted | Out-String
 $secure = ConvertTo-SecureString $script -asPlainText -force
 $export = $secure | ConvertFrom-SecureString -key $key
 Set-Content $encrypted $export
 "Script '$decrypted' has been encrypted as '$encrypted'"
 #commandline generate
 # powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File Decrypt.ps1 1,0,5,9,56,34,254,211,4,4,2,23,42,54,33,200,1,34,2,7,6,9,35,37
