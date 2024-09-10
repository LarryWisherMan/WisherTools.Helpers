# WisherTools.Helpers

The WisherTools.Helpers module is a collection of essential utility functions designed to assist with common tasks in PowerShell scripting. This module provides reusable components for managing directories, working with PowerShell functions dynamically, verifying system availability through network pings, and generating backup file paths. It streamlines various processes that are frequently used across different scripts and modules, offering a robust set of helper tools to enhance efficiency and maintainability.

**Function Overview**

1. **Get-DirectoryPath**  
   Converts a base path to a local or UNC format based on whether the target is local or remote.

2. **Get-FunctionScriptBlock**  
   Retrieves the script block of a specified PowerShell function.

3. **Get-BackupFilePath**  
   Generates a unique backup file path with a timestamp.

4. **Test-DirectoryExistence**  
   Ensures that a directory exists; creates it if necessary.

5. **Test-ComputerPing**  
   Pings a computer to check if it is online with a configurable timeout.
