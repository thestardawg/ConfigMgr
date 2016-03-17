#For those computers you are trying to image, that simply reboot before they let you select a task sequence, because they don't have the right nic driver in the boot image....
#Put the folders of potential drivers on a flash drive (F:\ in the script). Run this PS code:

$driverpaths = get-childitem "F:\" -recurse | where {$_.extension -eq ".inf"}
foreach ($driver in $driverpaths){
$fullpath = $driver.FullName
"drvload $fullpath" | out-file F:\installdrivers.bat -Encoding ascii -append
"ipconfig" | out-file F:\installdrivers.bat -Encoding ascii -append
"pause" | out-file F:\installdrivers.bat -Encoding ascii -append
}