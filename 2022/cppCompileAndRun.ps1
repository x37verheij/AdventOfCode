# First bypass script execution policy for this session:
# Set-ExecutionPolicy Bypass -Scope Process

param([Parameter(Mandatory=$true)][int]$DayNumber)

function Write-Hashtag($nr) {
    switch ($nr) {
        1 { Write-Host "#" -Foregroundcolor "red" -NoNewLine }
        2 { Write-Host "#" -Foregroundcolor "magenta" -NoNewLine }
        3 { Write-Host "#" -Foregroundcolor "blue" -NoNewLine }
        4 { Write-Host "#" -Foregroundcolor "green" -NoNewLine }
        5 { Write-Host "#" -Foregroundcolor "yellow" -NoNewLine }
    }
}

function Write-Hashtags([string]$word) {
    foreach ($nr in @(1, 2, 3, 4, 5, 4, 3, 2, 1, 2, 3, 4)) {
        Write-Hashtag $nr
    }
    Write-Host $word -Foregroundcolor "yellow" -NoNewLine
    foreach ($nr in @(4, 3, 2, 1, 2, 3, 4, 5, 4, 3, 2, 1)) {
        Write-Hashtag $nr
    }
    Write-Host
}

Write-Host "`n"
Write-Hashtags " BUILD "
Write-Host "..."

g++ .\day$DayNumber.cpp -o day$DayNumber -std=c++11

Write-Hashtags "  RUN  "

. ".\day$DayNumber.exe"

Write-Hashtags "  END  "
Write-Host "`n"
