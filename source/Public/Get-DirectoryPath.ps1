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
