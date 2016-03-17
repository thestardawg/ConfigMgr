Get-Item HKCU:\Software\Microsoft\ServerManager
Get-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon | select DoNot OpenServerManagerAtLogon | Ft –AutoSize
New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value “0x1” –Force