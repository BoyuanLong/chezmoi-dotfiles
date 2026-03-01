# CLAUDE.md — Chezmoi Source Directory

This is the chezmoi source directory. Files here are templates/sources that chezmoi deploys to `~/`.

## Quick Reference

- `chezmoi apply -v` — deploy changes to home directory
- `chezmoi diff` — preview what would change
- `chezmoi edit <target>` — edit a managed file's source

## Layout

- `dot_dotfiles/` → deploys to `~/.dotfiles/` (all config files)
- `.chezmoiexternal.toml` — external plugin archives (10 plugins)
- `.chezmoi.toml.tmpl` — config template (prompts for git name/email)
- `symlink_dot_vim` → creates `~/.vim` symlink
- `modify_dot_*` — scripts that ensure source lines in rc files
- `run_once_*` / `run_onchange_*` — setup scripts (git config, SSH key)

## Editing Config Files

Config files live in `dot_dotfiles/`. Edit them there, then `chezmoi apply`.
The `dfu` shell alias runs `chezmoi update` to pull and apply from remote.
