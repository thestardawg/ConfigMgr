$compName = "IT-HyperT39"

Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')
Import-Module ActiveDirectory -Function Remove-ADObject

try {
    Write-Output "Searching for AD Computer $compname"
    $comp = Get-AdComputer $compName -ErrorAction Continue
}
catch {
    Write-Output "AD Computer $compName was not found"
    $comp = $null
}

if ($comp.DistinguishedName -ne $null) {
    Write-Output "Removing AD Computer $compName"
    $comp.DistinguishedName | Remove-ADObject -Recursive -Confirm:$false
    Write-Output "AD Computer $compName was removed"
} else {
}

try {
    Write-Output "Removing SCCM Computer $compName"
    $PSD = Get-PSDrive -PSProvider CMSITE
    Set-Location "$($PSD):"
    Remove-CMDevice -Name $compName -Confirm:$false -Force -ErrorAction Stop
    Write-Output "SCCM Computer $compName was removed"
}
catch {
    Write-Output "SCCM Computer $compName was not found"
}
Set-Location "C:"