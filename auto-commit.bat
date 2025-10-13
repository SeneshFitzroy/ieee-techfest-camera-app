@echo off
setlocal enabledelayedexpansion

REM --- 1. Define the Date Range for October 2025 ---
REM The range is 23 days long (from Oct 6 to Oct 28).
set /a "MIN_DAY=6"
set /a "MAX_DAY=28"

REM --- 2. Calculate a Random Day within the Range ---
REM Generates a number between 0 and (MAX_DAY - MIN_DAY)
set /a "RANGE_SIZE=MAX_DAY - MIN_DAY + 1"
set /a "RANDOM_OFFSET=!RANDOM! %% !RANGE_SIZE!"
REM Adds the minimum day to the offset to get the final date
set /a "RANDOM_DAY=!MIN_DAY! + !RANDOM_OFFSET!"

REM --- 3. Determine Day of the Week (Approximate for Commits) ---
REM Since determining the actual day of the week is complex in Batch,
REM we will use a generic day abbreviation for the RFC 2822 format.
REM For random daily commits, "Mon" is often used as a neutral placeholder.
set "DAY_ABBREV=Mon"

REM --- 4. Format the Date for Git Metadata ---
REM Uses a fixed time (1:15 PM) for consistency.
set "COMMIT_DATE=!DAY_ABBREV! Oct !RANDOM_DAY! 13:15:00 2025 +0530"

REM --- 5. Stage Changes ---
echo Staging all changes with 'git add .'
git add .
if %ERRORLEVEL% neq 0 (
echo.
echo ❌ ERROR: 'git add .' failed. Is this a Git repository?
goto :CommitFailed
)

REM --- 6. Prepare Commit Message (File List and Changes) ---
set "FILES="
for /f "delims=" %%i in ('git diff --cached --name-only 2^>NUL') do set "FILES=%%i, !FILES!"
set "FILES=!FILES: ~1!"

set "CHANGES="
for /f "delims=" %%j in ('git diff --cached ^| findstr /v "^[+-][+-][+-]\|^index\|^---\|^+++"') do set "CHANGES=!CHANGES!%%j "

set "CHANGES_SNIPPET=!CHANGES:~0,50!..."
if not defined FILES set "FILES=(No staged files found)"
if not defined CHANGES set "CHANGES_SNIPPET=(No visible changes)"

REM --- 7. Construct Final Message ---
set "MSG=feat: Updated !FILES! - Changes: !CHANGES_SNIPPET! - Committed on October !RANDOM_DAY!, 2025"

REM --- 8. Set Environment Variable and Commit with the Desired Date ---
echo.
echo Attempting commit with date: %COMMIT_DATE%
set "GIT_COMMITTER_DATE=!COMMIT_DATE!"
git commit --date="!COMMIT_DATE!" -m "!MSG!"

REM --- 9. Check for Errors and Push ---
if !ERRORLEVEL! neq 0 (
goto :CommitFailed
) else (
echo.
echo ✅ Commit successful! Date set to: Oct !RANDOM_DAY!, 2025.
echo.
git push origin main
)

goto :EOF

:CommitFailed
echo.
echo ❌ Commit failed. Please run 'git commit' manually to see the error.
pause
endlocal