# Changelog for WisherTools.Helpers

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added detailed comment-based help and Unit Tests to all public functions in the
`WisherTools.Helpers` module. This provides better guidance and documentation
for the following functions:
  - `Get-DirectoryPath`
  - `Get-FunctionScriptBlock`
  - `New-UniqueFilePath`
  - `Test-ComputerPing`
  - `Test-DirectoryExistence`
  
- Added module PSData and build config

- Added warning to `New-UniqueFilePath` when the specified directory does not
exist and automatically creates the directory.

- Environment variables (`FILE_DIRECTORY`, `FILE_PREFIX`, `FILE_EXTENSION`) are
now used as default parameters for `New-UniqueFilePath`.

- Created new function `New-UniqueFilePath`, a more generic version of
`Get-BackupFilePath`, to generate unique file paths with customizable
prefixes, directories, and extensions.

- Icon Url in psd1

### Changed

- Replaced hardcoded defaults in `Get-BackupFilePath` with dynamic environment
variables and made the function more generic.

- Updated `New-UniqueFilePath` to use environment variables for default values
and fallback defaults if not set.

## [v0.1.0] - 2024-09-07

### Changed

- Removed Test Requirements to Test release

### Fixed

- Updated Pipeline to pass deploy
