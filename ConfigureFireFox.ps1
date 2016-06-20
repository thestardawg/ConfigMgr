#Michael Staton
#06-20-2016
#Script to utilize SCCM Config Item to Configure Firefox
#Variables
$script:temp = "$Env:WinDir\Temp\"
$script:local = "C:\Program Files (x86)\Mozilla Firefox\defaults\pref"
$script:config = "C:\Program Files (x86)\Mozilla Firefox"
$script:scriptDir = "\\1ndcitvwcm01\sccm_store\Software\Mozilla\FireFox Config"

function script:Installed {
	If (Test-Path "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"){
	$script:Inst = $True
	}
	Elseif (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe"){
	$script:Inst = $True
	}
	Else {
	$script:Inst = $False
	}
} #end Installed
function script:AddConfig {
	If ($Inst){
	#del $temp\FirefoxTools -Recurse -Force -ErrorAction SilentlyContinue
	new-item "$Env:WinDir\Temp\FireFoxConfig" -itemtype directory | Out-null
	cp $scriptDir\*.cfg "C:\Windows\Temp\FireFoxConfig"
    cp $scriptDir\*.js "C:\Windows\Temp\FireFoxConfig"
	cp $temp\FireFoxConfig\mozilla.cfg $config
    cp $temp\FireFoxConfig\local-settings.js $local
	del $temp\FireFoxConfig -Recurse -Force
	} #endif
} #end AddCert
Installed #Run function
AddConfig #Run function