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

Describe "Get-DirectoryPath" -Tag "Public" {
    Context "When IsLocal is $true" {
        It "Should convert UNC path to local path format" {
            $BasePath = "\\RemotePC\C$\Files"
            $ComputerName = "RemotePC"
            $IsLocal = $true

            $result = Get-DirectoryPath -BasePath $BasePath -ComputerName $ComputerName -IsLocal $IsLocal

            $result | Should -Be "C:\Files"
        }
    }

    Context "When IsLocal is $false" {
        It "Should convert local path to UNC path format" {
            $BasePath = "C:\Files"
            $ComputerName = "RemotePC"
            $IsLocal = $false

            $result = Get-DirectoryPath -BasePath $BasePath -ComputerName $ComputerName -IsLocal $IsLocal

            $result | Should -Be "\\RemotePC\C$\Files"
        }
    }

    Context "When BasePath is not in expected format" {
        It "Should return the original path if IsLocal is $true" {
            $BasePath = "D:\OtherFiles"
            $ComputerName = "RemotePC"
            $IsLocal = $true

            $result = Get-DirectoryPath -BasePath $BasePath -ComputerName $ComputerName -IsLocal $IsLocal

            $result | Should -Be "D:\OtherFiles"
        }

        It "Should return the original path if IsLocal is $false" {
            $BasePath = "D:\OtherFiles"
            $ComputerName = "RemotePC"
            $IsLocal = $false

            $result = Get-DirectoryPath -BasePath $BasePath -ComputerName $ComputerName -IsLocal $IsLocal

            $result | Should -Be "\\RemotePC\D$\OtherFiles"
        }
    }
}
