$regkey = 'HKCU\Software\Microsoft\ServerManager'
$name = 'DoNotOpenServerManagerAtLogon'
$Compliance = 'Compliant'
$Check = Get-ItemProperty -Path "$regkey" -Name "$name" -ErrorAction SilentlyContinue
If ($Check) {$Compliance = 'Non-Compliant'}
$Compliance