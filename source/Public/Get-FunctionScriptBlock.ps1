function Get-FunctionScriptBlock {
    param (
        [string]$FunctionName
    )

    try {
        # Get the current definition (body) of the specified function dynamically
        $functionBody = (Get-Command -Name $FunctionName).Definition

        if (-not $functionBody) {
            throw "Function '$FunctionName' does not exist."
        }

        # Create the full function definition as a script block
        $fullFunctionScript = @"
function $FunctionName {
    $functionBody
}
"@

        return $fullFunctionScript
    } catch {
        Write-Error "Failed to retrieve the function '$FunctionName'. Error: $_"
        return $null
    }
}
