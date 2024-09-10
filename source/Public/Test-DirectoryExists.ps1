<#
.SYNOPSIS
Ensures that a specified directory exists, and creates it if necessary.

.DESCRIPTION
This function checks whether a directory exists. If the directory does not exist, it creates the directory at the specified path.

.PARAMETER Directory
The path of the directory to check or create.

.EXAMPLE
Test-DirectoryExists -Directory "C:\Backups"

Checks if the directory "C:\Backups" exists. If not, the function creates it.

.OUTPUTS
None

.NOTES
#>

function Test-DirectoryExists {
    param (
        [string]$Directory
    )

    if (-not (Test-Path $Directory)) {
        New-Item -Path $Directory -ItemType Directory -Force | Out-Null
    }
}
