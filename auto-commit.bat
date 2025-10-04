@echo off
setlocal enabledelayedexpansion

REM --- 1. Define the Fixed Commit Date ---
set "COMMIT_DATE=Sat Oct 4 13:15:00 2025 +0530"

REM --- 2. Stage Changes ---
echo Staging all changes with 'git add .'
git add .
if %ERRORLEVEL% neq 0 (
echo.
echo ERROR: 'git add .' failed. Is this a Git repository?
goto :CommitFailed
)

REM --- 3. Prepare Commit Message (File List and Changes) ---
set "FILES="
for /f "delims=" %%i in ('git diff --cached --name-only 2^>NUL') do set "FILES=%%i, !FILES!"
set "FILES=!FILES: ~1!"

set "CHANGES="
for /f "delims=" %%j in ('git diff --cached ^| findstr /v "^[+-][+-][+-]\|^index\|^---\|^+++"') do set "CHANGES=!CHANGES!%%j "

set "CHANGES_SNIPPET=!CHANGES:~0,50!..."
if not defined FILES set "FILES=(No staged files found)"
if not defined CHANGES set "CHANGES_SNIPPET=(No visible changes)"

REM --- 4. Construct Final Message ---
set "MSG=feat: Updated !FILES! - Changes: !CHANGES_SNIPPET! - Committed on October 4th, 2025"

REM --- 5. Set Environment Variable and Commit with the Desired Date ---
echo.
echo Attempting commit with date: %COMMIT_DATE%
set "GIT_COMMITTER_DATE=!COMMIT_DATE!"
git commit --date="!COMMIT_DATE!" -m "!MSG!"

REM --- 6. Check for Errors and Push ---
if !ERRORLEVEL! neq 0 (
goto :CommitFailed
) else (
echo.
echo Commit successful! Date set to: Sat Oct 4, 2025.
echo.
git push origin main
)

goto :EOF

:CommitFailed
echo.
echo Commit failed. Please run 'git commit' manually to see the error.
pause
endlocal