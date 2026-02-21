@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

set /p version=Enter new version (example 1.0.2): 

echo.
echo Updating package.json...

powershell -Command "(Get-Content package.json) -replace '\"version\": \".*\"', '\"version\": \"%version%\"' | Set-Content package.json"
if %errorlevel% neq 0 (
    echo ERROR updating package.json
    pause
    exit
)

echo.
echo Committing changes...
git add .
git commit -m "release v%version%"
git push origin main
if %errorlevel% neq 0 (
    echo ERROR during git push
    pause
    exit
)

echo.
echo Cleaning old build...

if exist dist (
    rmdir /s /q dist
)

if exist node_modules\.cache (
    rmdir /s /q node_modules\.cache
)

echo.
echo Building project...
npm run build
if %errorlevel% neq 0 (
    echo ERROR during build
    pause
    exit
)

echo.
echo Creating GitHub Release...
gh release create v%version% ^
dist\*.exe ^
dist\latest.yml ^
--title "Version %version%" ^
--notes "Release version %version%"
if %errorlevel% neq 0 (
    echo ERROR creating release
    pause
    exit
)

echo.
echo DONE! 🚀
pause