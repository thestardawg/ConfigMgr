Get-Item HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer
Get-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name ShowRunAsDifferentuserinStart | select ShowRunAsDifferentuserinStart | Ft –AutoSize
New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name ShowRunAsDifferentuserinStart -PropertyType DWORD -Value “0x1” –Force