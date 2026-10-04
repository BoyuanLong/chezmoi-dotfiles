# dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/). Configurations for zsh, vim, tmux, and git.

## Install on a new machine

```bash
brew install chezmoi   # or: sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init --apply BoyuanLong/chezmoi-dotfiles
```

You'll be prompted for your git name and email. Everything else is automatic:
- Config files deployed to `~/.dotfiles/`
- Plugins downloaded (vim, zsh, tmux, dircolors)
- `~/.vim` symlinked, source lines added to `~/.zshrc`, `~/.vimrc`, `~/.tmux.conf`
- Git global config set
- SSH key generated (if none exists)

## Update dotfiles from remote

```bash
dfu   # alias for chezmoi update
```

## Edit config files

```bash
chezmoi edit ~/.dotfiles/zsh/aliases.sh   # edit source file
chezmoi diff                               # preview changes
chezmoi apply                              # deploy to ~/
```

Then commit and push:

```bash
cd ~/.local/share/chezmoi
git add -A && git commit -m "message" && git push
```

## Local settings

Keep machine-specific settings and credentials in `~/.zshrc`, after the shared
source line. This file stays local; chezmoi preserves its contents when updating.

Existing local override files are also supported:
- `~/.shell_local_before` and `~/.zshrc_local_before` run before shared shell settings.
- `~/.shell_local_after` and `~/.zshrc_local_after` run after shared shell settings.
- `~/.vimrc_local` overrides shared Vim settings.
- `~/.tmux_local.conf` overrides shared tmux settings before plugins initialize.

When migrating from legacy symlinked rc files, back up `~/.dotfiles` and the rc
symlinks first. Keep only machine-specific additions in the new `~/.zshrc`;
chezmoi adds the shared source line. Keeping the old shared configuration there
would initialize plugins twice and override the new settings.

## Update a plugin version

Edit `.chezmoiexternal.toml` — change the commit hash in the archive URL, then `chezmoi apply`.

## What's included

- **zsh** — vi keybindings, completions, autosuggestions, syntax highlighting, custom prompt with git status
- **vim** — Pathogen + plugins (lightline, NERDTree, NERDCommenter, solarized, C++ syntax)
- **tmux** — vim-style navigation, prefix highlight, solarized colors
- **git** — aliases, pretty log formats, solarized grep colors
