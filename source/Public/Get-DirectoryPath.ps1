<#
.SYNOPSIS
Converts a base path to either a local or UNC path format.

.DESCRIPTION
This function converts a base path to a local path if the target is on the local computer, or to a UNC format if the target is on a remote computer.

.PARAMETER BasePath
The base directory path that needs to be converted.

.PARAMETER ComputerName
The name of the computer where the directory is located.

.PARAMETER IsLocal
Boolean value indicating if the target is local. If true, the function returns the local path format; if false, it returns a UNC path.

.EXAMPLE
Get-DirectoryPath -BasePath "C:\Files" -ComputerName "RemotePC" -IsLocal $false

Converts the local path "C:\Files" to a UNC path for the remote computer.

.OUTPUTS
System.String

.NOTES
#>

function Get-DirectoryPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BasePath,

        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [bool]$IsLocal  # Determines whether to return local or UNC format
    )

    if ($IsLocal) {
        # Convert UNC to local format
        $localPath = $BasePath -replace '(?:.+)\\([a-zA-Z])\$\\', '$1:\'
        return $localPath
    }
    else {
        # Convert local path to UNC format
        $uncPath = $BasePath -replace '^([a-zA-Z]):\\', "\\$ComputerName\`$1`$\"
        return $uncPath
    }
}
