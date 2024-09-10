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

Describe 'Test-ComputerPing' -Tag 'Public' {

    Context "When the computer is reachable" {
        It "should return true when the ping is successful" {
            # Mock Get-CimInstance to simulate a successful ping response
            Mock Get-CimInstance {
                [pscustomobject]@{ StatusCode = 0 }
            }

            $result = Test-ComputerPing -ComputerName "ReachableComputer"
            $result | Should -Be $true
        }
    }

    Context "When the computer is unreachable" {
        It "should return false when the ping fails" {
            # Mock Get-CimInstance to simulate a failed ping response
            Mock Get-CimInstance {
                [pscustomobject]@{ StatusCode = 11010 }  # Example failure status code
            }

            $result = Test-ComputerPing -ComputerName "UnreachableComputer"
            $result | Should -Be $false
        }
    }

    Context "When an error occurs during the ping" {
        It "should return false when Get-CimInstance throws an exception" {
            # Mock Get-CimInstance to throw an error
            Mock Get-CimInstance { throw "Ping failed" }

            $result = Test-ComputerPing -ComputerName "ErrorComputer"
            $result | Should -Be $false
        }
    }

    Context "When a custom timeout is provided" {
        It "should respect the custom timeout value" {
            # Mock Get-CimInstance to simulate a successful ping with a custom timeout
            Mock Get-CimInstance {
                param ($ClassName, $Filter)
                $Filter | Should -Match "Timeout=5000"
                [pscustomobject]@{ StatusCode = 0 }
            }

            $result = Test-ComputerPing -ComputerName "ReachableComputer" -Timeout 5000
            $result | Should -Be $true
        }
    }

    Context "When validating the query parameter" {
        It "should call Get-CimInstance with the correct query" {
            # Mock Get-CimInstance but don't simulate any result to inspect the parameters
            Mock Get-CimInstance { [pscustomobject]@{ StatusCode = 0 } }

            # Call Test-ComputerPing
            $result = Test-ComputerPing -ComputerName "TestComputer" -Timeout 5000

            # Use Assert-MockCalled with a parameter filter to check that Get-CimInstance was called with the correct Filter parameter
            Assert-MockCalled Get-CimInstance -ParameterFilter {
                $Filter -eq "Address='TestComputer' AND Timeout=5000"
            }
        }

        It "should call Get-CimInstance with default timeout" {
            # Mock Get-CimInstance
            Mock Get-CimInstance { [pscustomobject]@{ StatusCode = 0 } }

            # Call Test-ComputerPing with no explicit timeout (uses default)
            $result = Test-ComputerPing -ComputerName "TestComputer"

            # Assert that the Filter parameter is constructed with the default timeout
            Assert-MockCalled Get-CimInstance -ParameterFilter {
                $Filter -eq "Address='TestComputer' AND Timeout=2000"
            }
        }
    }

}
