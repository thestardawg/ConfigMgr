# create the SCCM tasksequence object
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment

############# Define variables ################

# Query the wmi of the computer for the status of the TPM chip
if ((Get-WmiObject -class Win32_Tpm -namespace "root\CIMV2\Security\MicrosoftTpm").IsOwned_InitialValue){
	$tsenv.Value("TPMIsOwned")="True"
}
if ((Get-WmiObject -class Win32_Tpm -namespace "root\CIMV2\Security\MicrosoftTpm").IsActivated_InitialValue){
	$tsenv.Value("TPMIsActive")="True"
}