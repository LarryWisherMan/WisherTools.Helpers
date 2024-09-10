# WisherTools.Helpers

<div align="center">
  <img src="https://raw.githubusercontent.com/LarryWisherMan/ModuleIcons/main/WisherTools.Helpers.png"
   alt="WisherTools.Helpers Icon" width="400" />
</div>

The **WisherTools.Helpers** module is a collection of helper functions I often
keep using. It is designed to assist with common tasks in PowerShell scripting.
This module provides reusable components for managing directories, working with
PowerShell functions dynamically, verifying system availability through network
pings, and generating unique backup file paths. This module is sure to grow as
I am hoping to reuse common functions.

## **Used In**

Currently I use **WisherTools.Helpers** module in few other modules I have
developed to help reuse code. It is currently used in the following modules:

- [WinRegOps](https://github.com/LarryWisherMan/WinRegOps): A module for managing
  Windows Registry operations.
- [WinProfileOps](https://github.com/LarryWisherMan/WinProfileOps): A module for
  handling Windows user profiles.
- [WinDirOps](https://github.com/LarryWisherMan/WinDirOps): A module for working
with Windows directories.

## **Installation**

To install **WisherTools.Helpers**, you have two options:

1. **Install from PowerShell Gallery**  
   You can install the module directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/WisherTools.Helpers)
   using the `Install-Module` command:

   ```powershell
   Install-Module -Name WisherTools.Helpers
   ```

1. **Install from GitHub Releases**  
   You can also download the latest release from the [GitHub Releases page](https://github.com/LarryWisherMan/WisherTools.Helpers/releases).
   Download the `.zip` file of the release, extract it, and place it in one of
   your `$PSModulePath` directories.

## **Function Overview**

### 1. **Get-DirectoryPath**

   Converts a base path to either a local or UNC format depending on whether the
   target is local or remote.

- **Parameters**:
  - `BasePath`: The base directory path that needs to be converted.
  - `ComputerName`: The name of the computer where the directory is located.
  - `IsLocal`: A boolean indicating if the target is local (`$true`) or remote (`$false`).

- **Example**:

     ```powershell
     Get-DirectoryPath -BasePath "C:\Files" -ComputerName "RemotePC" -IsLocal $false
     ```

     Converts the local path "C:\Files" to a UNC path for the remote computer.

- **Outputs**: `System.String` (The converted path in local or UNC format.)

---

### 2. **Get-FunctionScriptBlock**

   Retrieves the script block of a specified PowerShell function.

- **Parameters**:
  - `FunctionName`: The name of the PowerShell function to retrieve the script
  block for.

- **Examples**:

     ```powershell
     Get-FunctionScriptBlock -FunctionName 'Get-Process'
     ```

     Retrieves the script block of the 'Get-Process' function.

     ```powershell
     Get-FunctionScriptBlock -FunctionName 'Test-Function'
     ```

     Retrieves the script block of 'Test-Function' if it exists.

- **Outputs**: `System.String` (The full script block of the function.)

---

### 3. **New-UniqueFilePath**

   Generates a unique file path with a timestamp.

- **Parameters**:
  - `Directory`: The directory where the file will be saved (defaults to the environment
  variable `FILE_DIRECTORY` or the user's TEMP directory if not set).

  - `Prefix`: The prefix for the file name (defaults to the environment variable
  `FILE_PREFIX` or "File").

  - `Extension`: The file extension (defaults to the environment variable
   `FILE_EXTENSION` or ".txt").

- **Examples**:

     ```powershell
     New-UniqueFilePath -Directory "C:\Backups" -Prefix "UserBackup" -Extension ".reg"
     ```

     Generates a file path like `C:\Backups\UserBackup_20240909_141500.reg`.

     ```powershell
     New-UniqueFilePath -Directory "C:\Logs" -Prefix "Log" -Extension ".log"
     ```

     Generates a file path like `C:\Logs\Log_20240909_141500.log`.

- **Outputs**: `System.String` (The full path of the newly generated file.)

---

### 4. **Test-DirectoryExistence**

   Ensures that a specified directory exists, and creates it if necessary.

- **Parameters**:
  - `Directory`: The path of the directory to check or create.

- **Example**:

     ```powershell
     Test-DirectoryExistence -Directory "C:\Backups"
     ```

     Checks if the directory "C:\Backups" exists. If not, it creates it.

- **Outputs**: None.

---

### 5. **Test-ComputerPing**

   Pings a computer to check if it is online with a configurable timeout.

- **Parameters**:
  - `ComputerName`: The name of the computer to be pinged.
  - `Timeout`: The timeout value for the ping request in milliseconds (default
  is 2000 ms).

- **Example**:

     ```powershell
     Test-ComputerPing -ComputerName "RemotePC" -Timeout 3000
     ```

     Pings the computer "RemotePC" with a timeout of 3 seconds to check if it's online.

- **Outputs**: `System.Boolean` (Returns `true` if the computer is reachable,
`false` otherwise.)
