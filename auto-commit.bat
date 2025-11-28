# --- CONFIGURATION ---
$Year = 2024
$AuthorName = "AutoBackfill"
$FileName = "activity_filler.txt"

# Create a dummy file if it doesn't exist
if (-not (Test-Path $FileName)) { New-Item $FileName -ItemType File }

# Get the first and last day of 2024
$StartDate = Get-Date -Date "$Year-01-01"
$EndDate = Get-Date -Date "$Year-12-31"

Write-Host "Starting backfill for year $Year..." -ForegroundColor Cyan

# Loop through every single day of the year
for ($date = $StartDate; $date -le $EndDate; $date = $date.AddDays(1)) {
    
    # 1. format the date for Git (ISO 8601)
    $dateString = $date.ToString("yyyy-MM-dd HH:mm:ss")
    
    # 2. Modify a file so Git sees a change (append a dot)
    Add-Content -Path $FileName -Value "."
    
    # 3. Stage the file
    git add $FileName
    
    # 4. Commit with the specific backdated timestamp
    # We use environment variables to force the date
    $Env:GIT_COMMITTER_DATE = "$dateString"
    $Env:GIT_AUTHOR_DATE = "$dateString"
    
    git commit -m "Backfill commit for $dateString" > $null
    
    Write-Host "Committed: $dateString" -ForegroundColor Green
}

# Clean up environment variables
Remove-Item Env:\GIT_COMMITTER_DATE
Remove-Item Env:\GIT_AUTHOR_DATE

Write-Host "------------------------------------------------"
Write-Host "Success! 2024 is now fully covered." -ForegroundColor Yellow
Write-Host "Run 'git push' to update your GitHub graph." -ForegroundColor Yellow