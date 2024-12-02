@echo off
setlocal enabledelayedexpansion

REM --- 1. Master List of Missing Dates (YYYY-MM-DD) ---
set "MISSING_DATES=2024-12-02,2024-12-04,2024-12-06,2024-12-09,2024-12-11,2024-12-13,2024-12-16,2024-12-18,2024-12-20,2024-12-23,2024-12-25,2024-12-27,2024-12-30,2025-01-01,2025-01-03,2025-01-06,2025-01-08,2025-01-10,2025-01-13,2025-01-15,2025-01-17,2025-01-20,2025-01-22,2025-01-24,2025-01-27,2025-01-29,2025-01-31,2025-02-03,2025-02-05,2025-02-07,2025-02-10,2025-02-12,2025-02-14,2025-02-17,2025-02-19,2025-02-21,2025-02-24,2025-02-26,2025-02-28,2025-03-03,2025-03-05,2025-03-07,2025-03-10,2025-03-12,2025-03-14,2025-03-17,2025-03-19,2025-03-21,2025-03-24,2025-03-26,2025-03-28,2025-03-31,2025-04-02,2025-04-04,2025-04-07,2025-04-09,2025-04-11,2025-04-14,2025-04-16,2025-04-18,2025-04-21,2025-04-23,2025-04-25,2025-04-28,2025-04-30,2025-05-02,2025-05-05,2025-05-07,2025-05-09,2025-05-12,2025-05-14,2025-05-16,2025-05-19,2025-05-21,2025-05-23,2025-05-26,2025-05-28,2025-05-30,2025-06-02,2025-06-04,2025-06-06,2025-06-09,2025-06-11,2025-06-13,2025-06-16,2025-06-18,2025-06-20,2025-06-23,2025-06-25,2025-06-27,2025-06-30,2025-07-02,2025-07-04,2025-07-07,2025-07-09,2025-07-11,2025-07-14,2025-07-16,2025-07-18,2025-07-21,2025-07-23,2025-07-25,2025-07-28,2025-07-30,2025-08-01,2025-08-04,2025-08-06,2025-08-08,2025-08-11,2025-08-13,2025-08-15,2025-08-18,2025-08-20,2025-08-22,2025-08-25,2025-08-27,2025-08-29,2025-09-01,2025-09-03,2025-09-05,2025-09-08,2025-09-10,2025-09-12,2025-09-15,2025-09-17,2025-09-19,2025-09-22,2025-09-24,2025-09-26,2025-09-29,2025-10-01,2025-10-03,2025-10-06,2025-10-08,2025-10-10,2025-10-13,2025-10-15,2025-10-17,2025-10-20,2025-10-22,2025-10-24,2025-10-27,2025-10-29,2025-10-31,2025-11-03,2025-11-05,2025-11-07,2025-11-10,2025-11-12,2025-11-14,2025-11-17,2025-11-19,2025-11-21,2025-11-24,2025-11-26,2025-11-28"

if not defined MISSING_DATES (
    echo.
    echo ✅ All contribution gaps have been filled!
    goto :EOF
)

REM --- 2. Extract the Next Oldest Missing Date (First in the list) ---
for /f "delims=," %%a in ("!MISSING_DATES!") do set "NEXT_DATE=%%a" & goto :ContinueProcessing

:ContinueProcessing
set "NEXT_DATE_FULL=!NEXT_DATE!, "
set "NEW_LIST=!MISSING_DATES:!NEXT_DATE_FULL!=!"

REM --- 3. Format Date for Git (YYYY-MM-DD to Mon Dec 02 13:15:00 2024 +0530) ---
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

REM Using Mon as a generic day for simplicity in batch file date formatting
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
    (
        echo @echo off
        echo setlocal enabledelayedexpansion
        echo.
        echo REM --- 1. Master List of Missing Dates (YYYY-MM-DD) ---
        echo set "MISSING_DATES=!NEW_LIST!"
        echo.
        REM ECHO the rest of the script here, starting from step 2
        echo REM --- 2. Extract the Next Oldest Missing Date (First in the list) ---
        echo for /f "delims=," %%%%a in ("!MISSING_DATES!") do set "NEXT_DATE=%%%%a" ^& goto :ContinueProcessing
        echo.
        echo :ContinueProcessing
        echo set "NEXT_DATE_FULL=!NEXT_DATE!, "
        echo set "NEW_LIST=!MISSING_DATES:!NEXT_DATE_FULL!=!"
        echo.
        echo REM --- 3. Format Date for Git (YYYY-MM-DD to Mon Dec 02 13:15:00 2024 +0530) ---
        echo set "YEAR=!NEXT_DATE:~0,4!"
        echo set "MONTH=!NEXT_DATE:~5,2!"
        echo set "DAY=!NEXT_DATE:~8,2!"
        echo.
        echo if "!MONTH!"=="12" set "MON_NAME=Dec"
        echo if "!MONTH!"=="01" set "MON_NAME=Jan"
        echo if "!MONTH!"=="02" set "MON_NAME=Feb"
        echo if "!MONTH!"=="03" set "MON_NAME=Mar"
        echo if "!MONTH!"=="04" set "MON_NAME=Apr"
        echo if "!MONTH!"=="05" set "MON_NAME=May"
        echo if "!MONTH!"=="06" set "MON_NAME=Jun"
        echo if "!MONTH!"=="07" set "MON_NAME=Jul"
        echo if "!MONTH!"=="08" set "MON_NAME=Aug"
        echo if "!MONTH!"=="09" set "MON_NAME=Sep"
        echo if "!MONTH!"=="10" set "MON_NAME=Oct"
        echo if "!MONTH!"=="11" set "MON_NAME=Nov"
        echo.
        echo REM Using Mon as a generic day for simplicity in batch file date formatting
        echo set "COMMIT_DATE=Mon !MON_NAME! !DAY! 13:15:00 !YEAR! +0530"
        echo.
        echo REM --- 4. Stage Changes (Mandatory) ---
        echo echo.
        echo echo Staging changes...
        echo git add .
        echo if %%%%ERRORLEVEL%%%% neq 0 (
        echo echo.
        echo echo ❌ ERROR: 'git add .' failed. Is this a Git repository?
        echo goto :CommitFailed
        echo )
        echo.
        echo REM --- 5. Prepare Commit Message (File List and Changes) ---
        echo set "FILES="
        echo for /f "delims=" %%%%i in ('git diff --cached --name-only 2^>NUL') do set "FILES=%%%%i, !FILES!"
        echo set "FILES=!FILES: ~1!"
        echo set "CHANGES="
        echo for /f "delims=" %%%%j in ('git diff --cached ^| findstr /v "^[+-][+-][+-]\|^index\|^---\|^+++"') do set "CHANGES=!CHANGES!%%%%j "
        echo.
        echo set "CHANGES_SNIPPET=!CHANGES:~0,50!..."
        echo if not defined FILES set "FILES=(No staged files found)"
        echo if not defined CHANGES set "CHANGES_SNIPPET=(No visible changes)"
        echo.
        echo set "MSG=feat: Gap Filler Commit: !FILES! - Changes: !CHANGES_SNIPPET! - Retroactively committed on !MON_NAME! !DAY!, !YEAR!"
        echo.
        echo REM --- 6. Set Environment Variable and Commit with the Desired Date ---
        echo echo.
        echo echo ⏳ Committing to date: !NEXT_DATE!
        echo set "GIT_COMMITTER_DATE=!COMMIT_DATE!"
        echo git commit --date="!COMMIT_DATE!" -m "!MSG!"
        echo.
        echo REM --- 7. Check for Errors and Push ---
        echo if !ERRORLEVEL! neq 0 (
        echo goto :CommitFailed
        echo ) else (
        echo echo.
        echo echo ✅ Commit successful! Date set to: !NEXT_DATE!.
        echo echo !NEW_LIST! Remaining gaps.
        echo echo.
        echo git push origin main
        echo )
        echo.
        echo goto :EOF
        echo.
        echo :CommitFailed
        echo echo.
        echo echo ❌ Commit failed. Please run 'git commit' manually to see the error.
        echo pause
        echo endlocal
    ) > "%~f0"

    echo ✅ Commit successful! Date set to: !NEXT_DATE!.
    echo %NEW_LIST% Remaining gaps.
    echo.
    git push origin main
)

goto :EOF

:CommitFailed
echo.
echo ❌ Commit failed. Please run 'git commit' manually to see the error.
pause
endlocal