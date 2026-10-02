@echo off
pwsh.exe -NoProfile -File "%~dp0agents.ps1" %*
exit /b %ERRORLEVEL%
