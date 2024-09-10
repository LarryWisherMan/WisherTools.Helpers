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

Describe 'Test-DirectoryExists' -Tag 'Public' {

    Context "When the directory exists" {
        It "should not create a new directory if it already exists" {
            # Mock Test-Path to return $true, meaning the directory already exists
            Mock Test-Path { $true }

            # Mock New-Item to ensure it is not called when the directory exists
            Mock New-Item

            # Call the function
            Test-DirectoryExists -Directory "C:\ExistingDirectory"

            # Assert that New-Item was not called since the directory exists
            Assert-MockCalled New-Item -Times 0
        }
    }

    Context "When the directory does not exist" {
        It "should create the directory if it does not exist" {
            # Mock Test-Path to return $false, meaning the directory does not exist
            Mock Test-Path { $false }

            # Mock New-Item to simulate directory creation
            Mock New-Item

            # Call the function
            Test-DirectoryExists -Directory "C:\NewDirectory"

            # Assert that New-Item was called to create the directory
            Assert-MockCalled New-Item -ParameterFilter { $Path -eq "C:\NewDirectory" -and $ItemType -eq "Directory" }
        }
    }

    Context "When creating the directory" {
        It "should create the directory with -Force and no output" {
            # Mock Test-Path to return $false
            Mock Test-Path { $false }

            # Mock New-Item and ensure it is called with the -Force switch
            Mock New-Item

            # Call the function
            Test-DirectoryExists -Directory "C:\ForcedDirectory"

            # Assert that New-Item was called with the -Force parameter
            Assert-MockCalled New-Item -ParameterFilter { $Path -eq "C:\ForcedDirectory" -and $ItemType -eq "Directory" -and $Force }
        }
    }

}
