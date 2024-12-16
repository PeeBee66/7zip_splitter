@echo off
setlocal EnableDelayedExpansion

:: Set up logging
set "LOGFILE=%~dp0\file_splitter.log"
set "TIMESTAMP=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"

:: Function to log messages
call :log "=== Script started at %TIMESTAMP% ==="
call :log "Working directory: %CD%"

:: Add error catching wrapper
cd /d "%~dp0"
set "ERROR_OCCURRED=0"

:: Settings matching the GUI configuration
set "CHUNK_SIZE=2000M"
set "COMPRESSION=0"
set "METHOD=gnu"
set "CPU_THREADS=4"

echo Starting file analysis...
call :log "Starting file analysis..."
echo.

:: Check if 7-Zip is installed
call :log "Checking 7-Zip installation..."
if not exist "C:\Program Files\7-Zip\7z.exe" (
    set "ERROR_MSG=ERROR: 7-Zip is not installed in the default location: C:\Program Files\7-Zip"
    echo !ERROR_MSG!
    call :log "!ERROR_MSG!"
    echo Please install 7-Zip and try again.
    set "ERROR_OCCURRED=1"
    goto :error
)

:: Find all files larger than 2GB using PowerShell
echo Files larger than 2GB:
echo ---------------------
call :log "Searching for files larger than 2GB..."

set "file_count=0"
for /f "delims=" %%A in ('powershell -command "Get-ChildItem -File | Where-Object { $_.Length -gt 2GB } | ForEach-Object { $_.Name + '|' + $_.Length }" 2^>nul') do (
    for /f "tokens=1,2 delims=|" %%B in ("%%A") do (
        set /a "file_count+=1"
        set "file_!file_count!_name=%%B"
        set "file_!file_count!_size=%%C"
        echo !file_count!^) %%B ^(!file_!file_count!_size! bytes^)
        call :log "Found large file: %%B (%%C bytes)"
    )
)

:: Check if we found any files
if !file_count! EQU 0 (
    set "ERROR_MSG=No files larger than 2GB found in the current directory."
    echo !ERROR_MSG!
    call :log "!ERROR_MSG!"
    set "ERROR_OCCURRED=1"
    goto :error
)

:: Prompt user to select a file
echo.
set /p "choice=Enter the number of the file you want to split (1-!file_count!) or Q to quit: "
call :log "User input: !choice!"

:: Check for quit
if /i "!choice!"=="Q" (
    call :log "User chose to quit"
    goto :eof
)

:: Validate input
if !choice! LSS 1 (
    set "ERROR_MSG=ERROR: Invalid selection (!choice!)"
    echo !ERROR_MSG!
    call :log "!ERROR_MSG!"
    set "ERROR_OCCURRED=1"
    goto :error
)
if !choice! GTR !file_count! (
    set "ERROR_MSG=ERROR: Invalid selection (!choice!)"
    echo !ERROR_MSG!
    call :log "!ERROR_MSG!"
    set "ERROR_OCCURRED=1"
    goto :error
)

:: Get selected file information
set "selected_file=!file_%choice%_name!"
set "selected_size=!file_%choice%_size!"
call :log "Selected file: !selected_file! (!selected_size! bytes)"

:: Prompt user for confirmation with simpler method
echo.
echo Selected file: !selected_file!
echo File size: !selected_size! bytes
echo Settings:
echo - Archive format: TAR
echo - Compression level: Store (0)
echo - Split size: 2000MB
echo - CPU threads: 4
echo - Compression method: GNU
echo.
set /p "confirm=Press Y to continue or N to cancel: "
call :log "Confirmation response: !confirm!"

if /i "!confirm!" NEQ "Y" (
    call :log "User cancelled at confirmation prompt"
    goto :end
)

:: Create tar archive with splits using specific settings
echo Creating split archive...
call :log "Starting 7-Zip archive creation..."

echo Command to execute: "C:\Program Files\7-Zip\7z.exe" a -ttar -v!CHUNK_SIZE! -mx!COMPRESSION! -mm=!METHOD! -mmt=!CPU_THREADS! "!selected_file!.tar" "!selected_file!"
call :log "Executing 7-Zip command..."

"C:\Program Files\7-Zip\7z.exe" a -ttar -v!CHUNK_SIZE! -mx!COMPRESSION! -mm=!METHOD! -mmt=!CPU_THREADS! "!selected_file!.tar" "!selected_file!" 2>&1
set "ZIP_ERROR=!errorlevel!"
call :log "7-Zip command completed with error level: !ZIP_ERROR!"

if !ZIP_ERROR! NEQ 0 (
    set "ERROR_MSG=ERROR: Failed to create the archive. Error level: !ZIP_ERROR!"
    echo !ERROR_MSG!
    call :log "!ERROR_MSG!"
    set "ERROR_OCCURRED=1"
    goto :error
) else (
    echo.
    echo Successfully created split archive.
    echo Files have been created as !selected_file!.tar.001, !selected_file!.tar.002, etc.
    echo.
    echo To reassemble later, use 7-Zip to extract the first file (!selected_file!.tar.001)
    call :log "Successfully created split archive for !selected_file!"
    echo.
)

goto :end

:error
echo.
if !ERROR_OCCURRED! EQU 1 (
    echo An error occurred during execution.
    echo Check the log file for details: %LOGFILE%
    echo.
    call :log "Script ended with errors"
)

:end
call :log "=== Script ended at %date% %time% ==="
echo Press any key to exit...
pause >nul
exit /b

:log
echo %~1 >> "%LOGFILE%"
exit /b
