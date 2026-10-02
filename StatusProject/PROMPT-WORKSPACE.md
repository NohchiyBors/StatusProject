# Prompt module: Workspace

Read in full before renaming existing items or accepting a user-supplied name under the sync root, resolving a name collision, creating a repository, `git clone` / `git init`, or checking/repairing Git metadata. Storage roles (sync root, clone root, metadata root) are defined in the core Workspace and Storage Policy.

## OneDrive-Safe File And Folder Names
Before creating, generating, copying, moving, or renaming any file or folder under the sync root, validate every new path segment and the complete destination path. Never knowingly create a name OneDrive cannot synchronize.

- Reject `"`, `*`, `:`, `<`, `>`, `?`, `/`, `\`, `|`, ASCII control characters, leading or trailing spaces, and a trailing period.
- Reject case-insensitive reserved names even with an extension: `.lock`, `CON`, `PRN`, `AUX`, `NUL`, `COM0`–`COM9`, `LPT0`–`LPT9`, `desktop.ini`; any name containing `_vti_`; any file name beginning with `~$`; and `forms` at a SharePoint/OneDrive library root.
- Normalize a generated name: keep a meaningful extension, replace each run of invalid characters with `-`, trim prohibited leading/trailing whitespace and trailing periods, prefix a reserved base name with `_`, collapse repeated separators where practical.
- After normalization, require a non-empty result and check case-insensitive collisions with siblings. Never overwrite or merge because two names normalize alike.
- For an invalid user-supplied name, use the normalized name only when the identity stays unambiguous, and report the change. Ask first when normalization could change meaning, break a public path/import/link, or collide.
- Never bulk-rename existing synchronized content without explicit authorization: first produce an old-to-new mapping, identify link/import/reference impacts, and use a reversible plan.
- Where platform or tenant rules are stricter, follow them and record the blocker or chosen safe fallback.

## GitHub Repository Default
When the user asks for a new project or repository, create it on GitHub as the durable remote, then create the local working copy from it. Stop at an unconnected local `git init` only when the user asks for a local-only/offline repository or GitHub is unavailable and the blocker is reported.

- "GitHub repository" means a source-code repository, not a GitHub Projects board, unless the board is requested too.
- Resolve owner or organization, repository name, and visibility before creation from documented project policy, then User Settings (*Default repository owner*, *Default visibility for new repositories*), else ask. Never make a repository public by assumption.
- Prefer creating an empty GitHub repository and cloning it so `origin` exists from the start. For an existing non-empty directory, create the GitHub repository, initialize locally with the required metadata placement, add `origin`, and verify the intended first push scope.
- Creation is an external state change: perform it only when the goal authorizes repository/project creation or `PROMPT.md#development-pre-authorization` covers it — never for a planning, audit, or documentation-only request. GitHub never replaces local Git metadata rules or commit/push/visibility/publication safety.

## Git Metadata Placement
Before `git clone` or `git init`, resolve the absolute destination. Outside OneDrive, use the clone root. Under the sync root, compute the mirrored metadata path under the metadata root first and use `--separate-git-dir`; the working tree may contain only a `.git` file with an absolute `gitdir:` pointer.

After clone, init, submodule, worktree, IDE, or agent Git operations under the sync root, verify:
1. `<worktree>/.git` is a file, not a directory.
2. Its `gitdir:` target is absolute, exists, and is under the metadata root.
3. `git -C <worktree> rev-parse --git-dir`, `rev-parse --show-toplevel`, and `status --short --branch` succeed.

From WSL, a sync-root worktree is read-only for Git: its `.git` file points to a Windows metadata path, so plain `git` commands fail there. Inspect with `GIT_DIR=<metadata root as /mnt/...> GIT_WORK_TREE=<worktree>` (status, log, diff); commit, tag, and push from Windows. Never rewrite the `gitdir:` pointer to a `/mnt/...` path — that breaks the Windows side.

A physical `.git` directory under the sync root is a violation. Preserve `HEAD`, index, staged state, and working-tree changes; never use `reset`, `clean`, destructive checkout/restore, or blind replacement. Inspect each repository, submodule, and worktree separately; move metadata only when the user authorized the correction, and verify status before and after. For an audit-only request, report the violation without moving or deleting anything.
