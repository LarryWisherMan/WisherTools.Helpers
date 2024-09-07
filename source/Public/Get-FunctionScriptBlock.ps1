<#
.SYNOPSIS
Retrieves the script block of a specified PowerShell function.

.DESCRIPTION
This function dynamically retrieves the script block definition of a specified PowerShell function. It can be used to examine the contents of an existing function.

.PARAMETER FunctionName
The name of the function whose script block is to be retrieved.

.EXAMPLE
Get-FunctionScriptBlock -FunctionName 'Get-Process'

Retrieves the script block of the 'Get-Process' function.

.OUTPUTS
System.String

.NOTES
#>

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
