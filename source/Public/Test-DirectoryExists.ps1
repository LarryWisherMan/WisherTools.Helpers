function Test-DirectoryExists {
    param (
        [string]$Directory
    )

    if (-not (Test-Path $Directory)) {
        New-Item -Path $Directory -ItemType Directory -Force | Out-Null
    }
}
