function Test-ComputerPing {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $false)]
        [int]$Timeout = 2000  # Default timeout is 4000 ms (4 seconds)
    )

    try {
        # Build the filter query to include the address and timeout
        $query = "Address='$ComputerName' AND Timeout=$Timeout"

        # Use Get-CimInstance to ping the computer with a timeout
        $pingResult = Get-CimInstance -ClassName Win32_PingStatus `
            -Filter $query -ErrorAction Stop

        # Check if the ping status is 0 (successful ping)
        if ($pingResult.StatusCode -eq 0) {
            Write-Verbose "Computer '$ComputerName' is online."
            return $true
        } else {
            Write-Verbose "Computer '$ComputerName' is offline or unreachable (StatusCode: $($pingResult.StatusCode))."
            return $false
        }
    } catch {
        Write-Verbose "Failed to ping computer '$ComputerName'. Error: $_"
        return $false
    }
}
