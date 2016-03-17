$TPM = Get-WmiObject -Class Win32_TPM -Namespace root\CIMV2\Security\MicrosoftTpm

# Enable, activate the chip, and allow the installation of a TPM owner.
$TPM.SetPhysicalPresenceRequest(10)

If(!(($TPM.IsEndorsementKeyPairPresent()).IsEndorsementKeyPairPresent)){

	# Enable the TPM encryption
	$TPM.CreateEndorsementKeyPair()

}

# Check if the TPM chip currently has an owner 
If(($TPM.IsEndorsementKeyPairPresent()).IsEndorsementKeyPairPresent){

	# Convert password to hash
	$OwnerAuth=$TPM.ConvertToOwnerAuth(“YourPassword”)

	# Clear current owner
	$TPM.Clear($OwnerAuth.OwnerAuth)

	# Take ownership
	$TPM.TakeOwnership($OwnerAuth.OwnerAuth)
} 