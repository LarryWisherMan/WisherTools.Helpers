<#
.SYNOPSIS
Retrieves the script block of a specified PowerShell function.

.DESCRIPTION
This function dynamically retrieves the script block definition of a specified PowerShell function.
It can be used to examine the contents of an existing function in detail, including its implementation.

.PARAMETER FunctionName
The name of the function whose script block is to be retrieved.
This parameter is mandatory. If not provided, the user will be prompted to supply a value.

.EXAMPLE
Get-FunctionScriptBlock -FunctionName 'Get-Process'

Retrieves the script block of the 'Get-Process' function.

.EXAMPLE
Get-FunctionScriptBlock -FunctionName 'Test-Function'

Retrieves the script block of the 'Test-Function' if it exists.

.OUTPUTS
System.String
The full script block of the function as a string.

.NOTES
If the function does not exist or if it exists but has no body, the function will throw an error.
This function uses the `Get-Command` cmdlet to retrieve the function definition.
#>

function Get-FunctionScriptBlock
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FunctionName
    )

    try
    {
        # Get the current definition (body) of the specified function dynamically
        $functionBody = (Get-Command -Name $FunctionName).Definition

        if (-not $functionBody)
        {
            throw "Function '$FunctionName' exists but has no body."
        }

        # Create the full function definition as a script block
        $fullFunctionScript = @"
function $FunctionName {
    $functionBody
}
"@

        return $fullFunctionScript
    }
    catch
    {
        throw "Failed to retrieve the function '$FunctionName'. Error: $_"
    }
}
