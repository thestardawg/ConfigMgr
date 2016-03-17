$regkey = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
$name = 'ShowRunAsDifferentuserinStart'
$Compliance = 'Compliant'
$Check = Get-ItemProperty -Path "$regkey" -Name "$name" -ErrorAction SilentlyContinue
If ($Check) {$Compliance = 'Non-Compliant'}
$Compliance