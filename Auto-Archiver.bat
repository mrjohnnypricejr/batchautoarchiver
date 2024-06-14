@echo off
setlocal enabledelayedexpansion

set "sourceFolder=.Projects" rem Folder to move old files from
set "archiveFolder=.Archives" rem Folder to move old files to
set "cutoffTime=365" rem Files older than this many days get moved to archiveFolder

echo Source Folder: "%sourceFolder%"
echo Archive Folder: "%archiveFolder%"

rem Get current date in a format compatible with comparisons
for /f "tokens=1-4 delims=/.- " %%a in ("%date%") do (
    set "currentDate=%%d%%b%%c"
)

rem Calculate the cutoffDate
for /f "tokens=1-3 delims=- " %%a in ('powershell -Command "(Get-Date).AddDays(-%cutoffTime%).ToString('yyyy-MM-dd')"') do (
    set "cutoffDate=%%a%%b%%c"
)

echo Current Date: %currentDate%
echo Cutoff Date: %cutoffDate%

call :moveFile "%sourceFolder%"
pause

exit

rem Function to move files
:moveFile
set "source=%~1"
echo Processing folder: "%source%"

rem Loop through all files in the source folder
for %%F in ("%source%\*") do (

    echo Processing file: "%%F"...

    rem Get the last modified date of the file
    for %%a in ("%%F") do (
        set "modifiedDate=%%~ta"
    )

    rem Format the modified date
    for /f "tokens=1-3 delims=/: " %%a in ("!modifiedDate!") do (
        set "modifiedDate=%%c%%a%%b"
    )

    rem Calculate the difference between currentDate and modifiedDate
    set /a "differenceOfDates=cutoffDate - modifiedDate"

    echo Last modified date of "%%F": !modifiedDate!

    rem Move file to archive if it's older than cutoffTime
    if !differenceOfDates! gtr 0 (
        echo Moving "%%F" to archive folder...
        
        if "%source%"=="%sourceFolder%" (
            rem Move the file to the archive folder
            move "%%F" "%archiveFolder%"
        ) else (
            rem Create corresponding folder structure in the archive folder if not already created
            set "relativePath=!source:%sourceFolder%\=!"
            md "%archiveFolder%\!relativePath!" 2>nul
        
            rem Move the file to the archive folder
            move "%%F" "%archiveFolder%\!relativePath!"
        )
    )
)

rem Loop through all the folders in the source folder
for /d %%D in ("%source%\*") do (
    call :moveFile "%%D"
)

rem Check if folder becomes empty after loop
set "isEmpty=true"
for %%a in ("%source%\*") do (
    set "isEmpty=false"
    goto :breakLoop
)

:breakLoop

rem Get the parent directory
for %%A in ("%source%\..") do set "parent_dir=%%~fA"

if "%isEmpty%"=="true" (
    echo Deleting !source!
    rmdir /s /q "!source!"

    rem Reset source to its parent directory
    set "source=!parent_dir!"
)

endlocal





