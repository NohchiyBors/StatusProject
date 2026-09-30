@echo off
rem Double-click: create %USERPROFILE%\.statusproject\USER-SETTINGS.md from the template.
rem Drag a filled settings file onto this script to use it as the source instead.
if "%~1"=="" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0init-user-settings.ps1"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0init-user-settings.ps1" -From "%~1"
)
pause
