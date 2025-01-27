@echo off
REM Set the default config directory
set NVIM_CONFIG_DIR=%USERPROFILE%\AppData\Local\nvim

REM Repository URL
set GIT_REPO_URL=https://github.com/Egrvigrf/nvim.git

REM If the config directory exists and is not a Git repository, delete it and clone again
if exist "%NVIM_CONFIG_DIR%" (
    if not exist "%NVIM_CONFIG_DIR%\.git" (
        echo "%NVIM_CONFIG_DIR% exists but is not a Git repository, deleting and recloning...
        rmdir /s /q "%NVIM_CONFIG_DIR%" REM Delete the directory
    ) else (
        echo "Config directory exists and is a Git repository, skipping deletion."
    )
) else (
    echo "Config directory does not exist, cloning the config repository..."
)

REM Clone the repository
git clone %GIT_REPO_URL% %NVIM_CONFIG_DIR%

REM Navigate to the config directory
cd /d "%NVIM_CONFIG_DIR%" || (
    echo "Unable to enter the directory!"
    exit /b 1
)

REM Check for updates from the repository
git fetch origin

REM Get the current local and remote branch status
for /f "delims=" %%i in ('git rev-parse @') do set LOCAL=%%i
for /f "delims=" %%i in ('git rev-parse @{u}') do set REMOTE=%%i

REM If the local branch is different from the remote, pull the updates
if "%LOCAL%" neq "%REMOTE%" (
    echo "Updates available, pulling..."
    git pull origin main  REM Assuming your default branch is main
    echo "Update complete!"
) else (
    echo "Config is up to date!"
)

pause
