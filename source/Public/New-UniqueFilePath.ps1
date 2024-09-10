<#
.SYNOPSIS
Generates a unique file path with a timestamp.

.DESCRIPTION
The New-UniqueFilePath function creates a unique file name with a timestamp and returns the full path
to the specified directory. It uses environment variables as defaults for the directory, prefix, and
file extension, with fallback defaults if the variables are not set. The function checks if the directory
exists and writes a warning if it does not.

.PARAMETER Directory
Specifies the directory where the file will be saved. Defaults to the environment variable `FILE_DIRECTORY`
or the user's TEMP directory if not set.

.PARAMETER Prefix
Specifies the prefix for the file name. Defaults to the environment variable `FILE_PREFIX` or "File".

.PARAMETER Extension
Specifies the file extension, including the dot (e.g., ".txt"). Defaults to the environment variable `FILE_EXTENSION`
or ".txt".

.EXAMPLE
PS> New-UniqueFilePath -Directory "C:\Backups" -Prefix "UserBackup" -Extension ".reg"
C:\Backups\UserBackup_20240909_141500.reg

.EXAMPLE
PS> New-UniqueFilePath -Directory "C:\Logs" -Prefix "Log" -Extension ".log"
C:\Logs\Log_20240909_141500.log

#>
function New-UniqueFilePath
{
    param (
        [string]$Directory = $env:FILE_DIRECTORY, # Default to environment variable
        [string]$Prefix = $env:FILE_PREFIX, # Default to environment variable
        [string]$Extension = $env:FILE_EXTENSION  # Default to environment variable
    )

    # Set fallback defaults if environment variables are not set
    if (-not $Directory)
    {
        $Directory = [System.IO.Path]::GetTempPath()  # Fallback to TEMP directory

        Write-Warning "Directory not specified. Using the Fallback directory: $Directory"
    }

    if (-not $Prefix)
    {
        $Prefix = "File"  # Fallback to default prefix
    }

    if (-not $Extension)
    {
        $Extension = ".txt"  # Fallback to default file extension
    }

    # Check if the directory exists, write a warning if it does not
    if (-not (Test-Path -Path $Directory))
    {
        Write-Warning "Directory '$Directory' does not exist. Creating it now."
        New-Item -Path $Directory -ItemType Directory -Force | Out-Null
    }

    # Generate a unique file name with a timestamp
    $dateTimeStamp = (Get-Date -Format "yyyyMMdd_HHmmss")
    $fileName = "$Prefix`_$dateTimeStamp$Extension"
    $filePath = Join-Path -Path $Directory -ChildPath $fileName

    return $filePath
}
