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
