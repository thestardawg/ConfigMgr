<#
.Synopsis
   Enables the .NET Framework Feature on Windows 8.1
.DESCRIPTION
   Enables the .NET Framework Feature on Windows 8.1 using a copy of the \sources\sxs folder
   content from the Windows 8.1 installation media
.PARAMETER Source
  Optional parameter pointing to the location where the SXS files are located, if no -Source 
  parameter is provided, the SXS folder is expected to be in the same folder as the script. 
.EXAMPLE
 Enable-NET35SP1.ps1 
.EXAMPLE
 Enable-NET35SP1.ps1 -Source R:\Win81\Sources\sxs
.LINK
   
.NOTES
  Version 1.0, by Alex Verboon
#>
 
[CmdletBinding(SupportsShouldProcess=$true)]
Param(
[Parameter(Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            ParameterSetName="SXSPath",
            HelpMessage= 'SXS Folder')]
            [String]$Source
)
 
 
Begin{
    If ((Get-windowsoptionalfeature -FeatureName NetFx3 -Online | Select-Object -ExpandProperty State) -ne "Enabled")
        {
        Write-Verbose ".NET Framework 3.5SP1 is not enabled on this system"
        if ([string]::IsNullOrEmpty($Source))
            {
            #No source path provided so set source path to SXS folder located in the script execution path
            # we'll check later if it actually exists
            $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
            $SxsSource = "$PSScriptRoot\SXS"
            }
        else
            {
            # set the Source to the provided path, we'll check later if it exists
            $SxsSource = $Source
            }
        }
    Else
        {
            Write-Output ".NET Framework 3.5 SP1 is already installed"
            Exit
        }
}
 
 
Process{
If ((Test-Path -Path "$SxsSource") -eq $false)
{
    Write-Error "SXS Sources: SxsSource not found"
} 
Else
{
    Write-Verbose "SXS Sources: $SxsSource found"
    If ($PScmdlet.ShouldProcess("Enabling .NET Framework 3.5 Feature using Sources in $SxsSource","",""))
    {
        Write-Output "Enabling .NET Framework 3.5 Feature"
        enable-windowsoptionalfeature -featurename NetFx3 -Online -NoRestart -LimitAccess -All -Source $SxsSource -LogLevel WarningsInfo -ErrorAction Continue
    }
}
}
 
 
End{
        If ((Get-windowsoptionalfeature -FeatureName NetFx3 -Online | Select-Object -ExpandProperty State) -eq "Enabled")
        {
            Write-Output "Enabling .NET Framework 3.5 SP1 completed "
        }
        Else
        {
            Write-Output "Enabling .NET Framework 3.5 SP1 not completed"
        }
}