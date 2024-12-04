@echo off
setlocal enabledelayedexpansion

REM --- 1. Master List of Missing Dates (YYYY-MM-DD) ---
REM These are the days from the analysis that have zero contributions.
set "MISSING_DATES=2024-12-04,2024-12-06,2024-12-11,2024-12-13,2024-12-18,2024-12-20,2024-12-25,2024-12-27,2025-01-01,2025-01-03,2025-01-06,2025-01-08,2025-01-10,2025-01-13,2025-01-15,2025-01-17,2025-01-20,2025-01-22,2025-01-24,2025-01-27,2025-01-29,2025-01-31,2025-02-05,2025-02-07,2025-02-12,2025-02-14,2025-02-19,2025-02-21,2025-02-26,2025-02-28,2025-03-03,2025-03-05,2025-03-10,2025-03-12,2025-03-17,2025-03-19,2025-03-24,2025-03-26,2025-03-31,2025-04-02,2025-04-07,2025-04-09,2025-04-14,2025-04-16,2025-04-21,2025-04-23,2025-04-28,2025-04-30,2025-05-05,2025-05-07,2025-05-12,2025-05-14,2025-05-19,2025-05-21,2025-05-26,2025-05-28,2025-06-06,2025-06-13,2025-06-20,2025-06-27,2025-07-07,2025-07-14,2025-07-21,2025-07-28,2025-08-04,2025-08-11,2025-08-18,2025-08-25,2025-09-01,2025-09-05,2025-09-08,2025-09-12,2025-09-15,2025-09-19,2025-09-22,2025-09-26,2025-09-29,2025-10-03,2025-10-10,2025-10-17,2025-10-24,2025-10-31,2025-11-03,2025-11-05,2025-11-07,2025-11-10,2025-11-12,2025-11-14,2025-11-17,2025-11-19,2025-11-21,2025-11-24,2025-11-26,2025-11-28"

if not defined MISSING_DATES (
    echo.
    echo ✅ All contribution gaps have been filled!
    goto :EOF
)

REM --- 2. Extract the Next Oldest Missing Date (First in the list) ---
for /f "delims=," %%a in ("!MISSING_DATES!") do set "NEXT_DATE=%%a" & goto :ContinueProcessing

:ContinueProcessing
set "NEW_LIST=!MISSING_DATES:!NEXT_DATE!,=!"
set "NEW_LIST=!NEW_LIST:!NEXT_DATE! =!"
set "NEW_LIST=!NEW_LIST:!=!"

REM --- 3. Format Date for Git (YYYY-MM-DD to Sat Oct 4 13:15:00 2025 +0530) ---
REM NOTE: We use a generic 'Mon' for the day of week to simplify the script.
set "YEAR=!NEXT_DATE:~0,4!"
set "MONTH=!NEXT_DATE:~5,2!"
set "DAY=!NEXT_DATE:~8,2!"

if "!MONTH!"=="12" set "MON_NAME=Dec"
if "!MONTH!"=="01" set "MON_NAME=Jan"
if "!MONTH!"=="02" set "MON_NAME=Feb"
if "!MONTH!"=="03" set "MON_NAME=Mar"
if "!MONTH!"=="04" set "MON_NAME=Apr"
if "!MONTH!"=="05" set "MON_NAME=May"
if "!MONTH!"=="06" set "MON_NAME=Jun"
if "!MONTH!"=="07" set "MON_NAME=Jul"
if "!MONTH!"=="08" set "MON_NAME=Aug"
if "!MONTH!"=="09" set "MON_NAME=Sep"
if "!MONTH!"=="10" set "MON_NAME=Oct"
if "!MONTH!"=="11" set "MON_NAME=Nov"

set "COMMIT_DATE=Mon !MON_NAME! !DAY! 13:15:00 !YEAR! +0530"

REM --- 4. Stage Changes (Mandatory) ---
echo.
echo Staging changes...
git add .
if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ ERROR: 'git add .' failed. Is this a Git repository?
    goto :CommitFailed
)

REM --- 5. Prepare Commit Message (File List and Changes) ---
set "FILES="
for /f "delims=" %%i in ('git diff --cached --name-only 2^>NUL') do set "FILES=%%i, !FILES!"
set "FILES=!FILES: ~1!"
set "CHANGES="
for /f "delims=" %%j in ('git diff --cached ^| findstr /v "^[+-][+-][+-]\|^index\|^---\|^+++"') do set "CHANGES=!CHANGES!%%j "

set "CHANGES_SNIPPET=!CHANGES:~0,50!..."
if not defined FILES set "FILES=(No staged files found)"
if not defined CHANGES set "CHANGES_SNIPPET=(No visible changes)"

set "MSG=feat: Gap Filler Commit: !FILES! - Changes: !CHANGES_SNIPPET! - Retroactively committed on !MON_NAME! !DAY!, !YEAR!"

REM --- 6. Set Environment Variable and Commit with the Desired Date ---
echo.
echo ⏳ Committing to date: !NEXT_DATE!
set "GIT_COMMITTER_DATE=!COMMIT_DATE!"
git commit --date="!COMMIT_DATE!" -m "!MSG!"

REM --- 7. Check for Errors and Push ---
if !ERRORLEVEL! neq 0 (
    goto :CommitFailed
) else (
    REM --- 8. SUCCESS: Update the script file with the NEW_LIST ---
    echo @echo off> "%~f0"
    echo setlocal enabledelayedexpansion>> "%~f0"
    echo.>> "%~f0"
    echo REM --- 1. Master List of Missing Dates (YYYY-MM-DD) --->> "%~f0"
    echo set "MISSING_DATES=!NEW_LIST!">>"%~f0"
    echo.>> "%~f0"
    echo REM (Remaining script code follows here, omitted for brevity)
    REM NOTE: In a real environment, you would echo the rest of the script here.
    
    echo ✅ Commit successful! Date set to: !NEXT_DATE!.
    echo %NEW_LIST% Remaining gaps:
    echo.
    git push origin main
)

goto :EOF

:CommitFailed
echo.
echo ❌ Commit failed. Please run 'git commit' manually to see the error.
pause
endlocal