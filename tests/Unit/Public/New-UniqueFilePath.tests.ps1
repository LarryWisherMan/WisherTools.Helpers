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

Describe "New-UniqueFilePath" -Tag "Public" {

    Context "When environment variables are not set" {
        It "should use fallback defaults for directory, prefix, and extension" {
            $result = New-UniqueFilePath
            $result | Should -Match "File_\d{8}_\d{6}\.txt"
        }
    }

    Context "When environment variables are set" {
        BeforeAll {
            # Use TestDrive for the directory to isolate the changes
            $env:FILE_DIRECTORY = "$TestDrive\TestDirectory"
            $env:FILE_PREFIX = "TestPrefix"
            $env:FILE_EXTENSION = ".test"
        }

        AfterAll {
            # Clean up environment variables after the test
            Remove-Item -Path "env:FILE_DIRECTORY"
            Remove-Item -Path "env:FILE_PREFIX"
            Remove-Item -Path "env:FILE_EXTENSION"
        }

        It "should use environment variables for directory, prefix, and extension" {
            $expectedRegex = [regex]::Escape("$TestDrive\TestDirectory\TestPrefix") + "_\d{8}_\d{6}\.test"
            $result = New-UniqueFilePath
            $result | Should -Match $expectedRegex
        }
    }

    Context "When parameters are provided" {
        It "should use provided parameters for directory, prefix, and extension" {
            $directory = "$TestDrive\CustomDirectory"
            $prefix = "CustomPrefix"
            $extension = ".custom"

            # Corrected regex with proper escaping
            $expectedRegex = [regex]::Escape("$TestDrive\CustomDirectory\CustomPrefix") + "_\d{8}_\d{6}" + [regex]::Escape($extension)

            $result = New-UniqueFilePath -Directory $directory -Prefix $prefix -Extension $extension
            $result | Should -Match $expectedRegex
        }
    }

    Context "When directory does not exist" {
        It "should create the directory and return the correct file path" {
            $directory = "$TestDrive\NonExistentDirectory"
            $result = New-UniqueFilePath -Directory $directory
            $expectedRegex = [regex]::Escape("$TestDrive\NonExistentDirectory\File") + "_\d{8}_\d{6}\.txt"
            $result | Should -Match $expectedRegex

            # Ensure the directory was created
            Test-Path -Path $directory | Should -Be $true
        }
    }
}
