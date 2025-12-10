@echo off
echo Choose a timer:
echo 1. 10 minutes
echo 2. 15 minutes
echo 3. 30 minutes
echo 4. 45 minutes
echo 5. 60 minutes
set /p choice=Enter your choice (1-5): 

if "%choice%"=="1" (
    timeout /t 600
    taskkill /IM Spotify.exe /F
)
if "%choice%"=="2" (
    timeout /t 900
    taskkill /IM Spotify.exe /F
)
if "%choice%"=="3" (
    timeout /t 1800
    taskkill /IM Spotify.exe /F
)
if "%choice%"=="4" (
    timeout /t 2700
    taskkill /IM Spotify.exe /F
)
if "%choice%"=="5" (
    timeout /t 3600
    taskkill /IM Spotify.exe /F
)

echo Done!
pause
