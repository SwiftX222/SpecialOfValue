@echo off
set /p version=Enter new version (example 1.0.2): 

echo.
echo Updating package.json...

powershell -Command "(Get-Content package.json) -replace '\"version\": \".*\"', '\"version\": \"%version%\"' | Set-Content package.json"

echo.
echo Committing changes...
git add .
git commit -m "release v%version%"
git push origin main

echo.
echo Building project...
npm run build

echo.
echo Creating GitHub Release...
gh release create v%version% ^
dist\*.exe ^
dist\latest.yml ^
--title "Version %version%" ^
--notes "Release version %version%"

echo.
echo DONE! 🚀
pause