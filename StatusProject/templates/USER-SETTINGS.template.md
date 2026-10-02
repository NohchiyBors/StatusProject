# USER SETTINGS

Per-user, per-machine values for StatusProject: paths, hosts, connection names, defaults. Operating rules stay in `StatusProject/PROMPT.md`; this file only supplies the values those rules refer to.

- Location: `~/.statusproject/USER-SETTINGS.md` (Windows: `%USERPROFILE%\.statusproject\USER-SETTINGS.md`), shared by all projects of this user on this machine. A project may override single keys in `StatusProject/USER-SETTINGS.local.md` (Git-ignored).
- Create or refresh it with `scripts/init-user-settings` (`.ps1`, `.sh`, or `.bat`); the script never overwrites an existing file.
- Leave a value as `<...>` or `unset` when it does not apply. Agents never guess an unset value: they ask once and suggest recording the answer here.
- No secrets. Record where credentials live (MCP connection name, SSH config host, secret-manager path), never the credentials.

## Communication
- Reply language: `<ru|en|...>`

## Storage
- Sync root (working trees that need cloud sync, e.g. OneDrive): `<absolute path|unset>`
- Clone root (ordinary clones without cloud sync): `<absolute path|unset>`
- Metadata root (Git metadata for sync-root working trees; required when a sync root is set): `<absolute path|unset>`
- Local StatusProject source: `<absolute path to the StatusProject source repository|unset>`
- Windows drive mount prefix (WSL only): `/mnt`

## Runtime
- Default development environment: `<remote Docker|local Docker|other: ...>`
- Remote Docker host: `<host or IP|unset>`
- Local Docker allowed without asking: `<yes|no>`
- SSH access: `<MCP connection name or SSH config host|unset>`
- Deployment platform access: `<e.g. Coolify MCP connection name|unset>`

## StatusProject
- StatusProject update check interval (days): `1`
- Auto-migrate state after update: `<yes|no>` (yes = the PM Preflight applies pending state migrations without asking; moves only)

## GitHub
- Default repository owner: `<user or organization|ask>`
- Default visibility for new repositories: `<private|public|ask>`
- Development pre-authorization: `yes` (yes = during development, dev transfer, commit, push, and GitHub branches/PRs/issues/Actions need no confirmation; `PROMPT.md#development-pre-authorization`)

## Notes
- `<other machine-specific facts agents need>`
