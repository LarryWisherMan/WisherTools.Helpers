<#
.SYNOPSIS
Generates a unique backup file path with a timestamp.

.DESCRIPTION
This function generates a unique backup file path by appending a timestamp to a user-defined or default file prefix. It is typically used to ensure that each backup file created has a unique name.

.PARAMETER BackupDirectory
The directory where the backup file will be saved. Defaults to "C:\LHStuff\UserProfileTools\RegProfBackup".

.PARAMETER Prefix
The prefix for the backup file name. Defaults to "ProfileListBackup".

.EXAMPLE
Get-BackupFilePath -BackupDirectory "C:\Backups" -Prefix "RegistryBackup"

Generates a backup file path in "C:\Backups" with the prefix "RegistryBackup".

.OUTPUTS
System.String

.NOTES
#>

function Get-BackupFilePath {
    param (
        [string]$BackupDirectory = "C:\LHStuff\UserProfileTools\RegProfBackup",
        [string]$Prefix = "ProfileListBackup"
    )

    # Generate a unique backup file name with timestamp
    $dateTimeStamp = (Get-Date -Format "yyyyMMdd_HHmmss")
    $backupFileName = "$Prefix`_$dateTimeStamp.reg"
    $backupPath = Join-Path -Path $BackupDirectory -ChildPath $backupFileName

    return $backupPath
}
