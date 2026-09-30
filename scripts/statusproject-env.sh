#!/usr/bin/env bash
# Shared helpers for the StatusProject Bash scripts. Sourced, never executed.
#
# Settings home resolution (sp_settings_home):
#   1. $STATUSPROJECT_HOME when set;
#   2. under WSL, the Windows user's %USERPROFILE%\.statusproject seen through the drive mount
#      (so Windows agents and WSL agents share one USER-SETTINGS.md, UPDATE-CHECK.md, PROJECTS.md);
#   3. otherwise $HOME/.statusproject.
# Path translation under WSL: sp_to_native turns `D:\x` / `D:/x` into `/mnt/d/x` for filesystem
# access; sp_to_windows turns `/mnt/d/x` back into `D:\x` so shared files keep one spelling.
# Outside WSL both functions return their input unchanged. Windows and PowerShell scripts are
# untouched by this file.
#
# Overrides (mainly for tests): STATUSPROJECT_WSL=1|0 forces WSL detection on or off;
# STATUSPROJECT_WSL_ROOT sets the drive mount prefix (default: the *Windows drive mount prefix*
# setting, else /mnt).

sp_is_wsl() {
  case "${STATUSPROJECT_WSL:-}" in
    1) return 0 ;;
    0) return 1 ;;
  esac
  grep -qi microsoft /proc/version 2>/dev/null
}

sp_mount_root() {
  local root="${STATUSPROJECT_WSL_ROOT:-}"
  if [ -z "$root" ] && [ -n "${SETTINGS_HOME:-}" ] && [ -f "$SETTINGS_HOME/USER-SETTINGS.md" ]; then
    root="$(grep -m1 -F -- '- Windows drive mount prefix' "$SETTINGS_HOME/USER-SETTINGS.md" | sed -E 's/^[^:]*:[[:space:]]*//; s/`//g; s/[[:space:]]+$//')"
    case "$root" in ''|\<*|unset) root="" ;; esac
  fi
  printf '%s' "${root:-/mnt}"
}

# D:\dir\file or D:/dir/file -> /mnt/d/dir/file (WSL only; other input unchanged)
sp_to_native() {
  local p="$1"
  if sp_is_wsl && [[ "$p" =~ ^([A-Za-z]):[\\/]?(.*)$ ]]; then
    local drive="${BASH_REMATCH[1]}" rest="${BASH_REMATCH[2]}"
    drive="$(printf '%s' "$drive" | tr '[:upper:]' '[:lower:]')"
    rest="${rest//\\//}"
    printf '%s/%s%s' "$(sp_mount_root)" "$drive" "${rest:+/$rest}"
  else
    printf '%s' "$p"
  fi
}

# /mnt/d/dir/file -> D:\dir\file (WSL only; other input unchanged)
sp_to_windows() {
  local p="$1" root
  root="$(sp_mount_root)"
  if sp_is_wsl && [[ "$p" == "$root"/[A-Za-z] || "$p" == "$root"/[A-Za-z]/* ]]; then
    local rest="${p#"$root"/}" drive
    drive="$(printf '%s' "${rest:0:1}" | tr '[:lower:]' '[:upper:]')"
    rest="${rest:2}"
    printf '%s:\\%s' "$drive" "${rest//\//\\}"
  else
    printf '%s' "$p"
  fi
}

sp_settings_home() {
  if [ -n "${STATUSPROJECT_HOME:-}" ]; then printf '%s' "$STATUSPROJECT_HOME"; return; fi
  if sp_is_wsl && command -v cmd.exe >/dev/null 2>&1; then
    local win
    win="$(cd / && cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r\n')"
    if [ -n "$win" ]; then
      win="$(sp_to_native "$win")"
      [ -d "$win" ] && { printf '%s/.statusproject' "$win"; return; }
    fi
  fi
  printf '%s/.statusproject' "$HOME"
}
