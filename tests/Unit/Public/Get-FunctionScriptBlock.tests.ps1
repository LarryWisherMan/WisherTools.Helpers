BeforeAll {
    $script:moduleName = 'WisherTools.Helpers'

    # If the module is not found, run the build task 'noop'.
    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        # Redirect all streams to $null, except the error stream (stream 2)
        & "$PSScriptRoot/../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

    # Re-import the module using force to get any code changes between runs.
    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName
}

Describe "Get-FunctionScriptBlock" -Tag "Public" {

    Context "When function name is valid" {
        It "Should return the script block of the existing function" {
            # Mock Get-Command to return a function definition for a known function
            Mock Get-Command {
                [pscustomobject]@{ Definition = 'Write-Output "Hello World"' }
            }

            $result = Get-FunctionScriptBlock -FunctionName 'TestFunction'

            # Expected full function script
            $expected = @"
function TestFunction {
    Write-Output "Hello World"
}
"@

            # Validate that the returned result matches the expected script block
            $result | Should -BeExactly $expected
        }
    }

    Context "When function exists but has no body" {
        It "Should throw an error if the function exists but has no body" {
            # Mock Get-Command to return an empty function body
            Mock Get-Command {
                [pscustomobject]@{ Definition = '' }
            }

            # Expect an exception when the function exists but has no body
            { Get-FunctionScriptBlock -FunctionName 'EmptyFunction' } | Should -Throw
        }
    }

    Context "When function name is invalid" {
        It "Should throw an error if function does not exist" {
            # Mock Get-Command to simulate a non-existent function
            Mock Get-Command { throw "CommandNotFoundException" }

            # Capture error and ensure it's thrown
            { Get-FunctionScriptBlock -FunctionName 'NonExistentFunction' } | Should -Throw
        }
    }

    Context "When an error occurs" {
        It "Should throw an error if retrieving the function fails" {
            # Mock Get-Command to simulate an error
            Mock Get-Command { throw "Some other error" }

            # Capture error and ensure it's thrown
            { Get-FunctionScriptBlock -FunctionName 'TestErrorFunction' } | Should -Throw
        }
    }
}
