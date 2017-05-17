#SCCM CB ConfigItem / Remediation to turn LMS off and disable from auto startup.

#Discovery - Script - String.
(get-wmiobject -namespace root\CIMv2 -class Win32_Service | where-object -filterscript {$_.Name -eq “LMS”}).started

#Remediation
$service = get-wmiobject -namespace root\cimv2 -class Win32_Service | where-object -filterscript {$_.Name -eq “lms”}
$service.changestartmode(“disabled”)
$service.stopservice()

#Compliance Rule
#Condition = False.  Remediation = Yes.