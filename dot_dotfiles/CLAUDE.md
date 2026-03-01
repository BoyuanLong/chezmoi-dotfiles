# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed by [chezmoi](https://www.chezmoi.io/). It manages configuration files for zsh, vim, tmux, and git. Chezmoi deploys files to `~/.dotfiles/` and uses external archives (replacing git submodules) for plugins.

## Installation and Updates

**Initial installation on a new machine:**
```bash
chezmoi init --apply <github-username>
```

**Apply changes after editing source files:**
```bash
chezmoi apply -v
```

**Update dotfiles from remote:**
```bash
dfu  # alias defined in zsh/aliases.sh - runs chezmoi update
```

**Edit a managed file:**
```bash
chezmoi edit ~/.dotfiles/zsh/aliases.sh
```

**See what would change:**
```bash
chezmoi diff
```

## Chezmoi Source Layout

The chezmoi source directory (`~/.local/share/chezmoi/`) maps to the home directory:

- `dot_dotfiles/` → `~/.dotfiles/` — all config files deployed here
- `.chezmoiexternal.toml` — external plugin archives (replaces git submodules)
- `.chezmoi.toml.tmpl` — prompts for git name/email on first init
- `symlink_dot_vim` → `~/.vim` symlink pointing to `~/.dotfiles/vim`
- `modify_dot_zshrc` — ensures `source ~/.dotfiles/zsh/zshrc.shared` in `~/.zshrc`
- `modify_dot_vimrc` — ensures `source ~/.dotfiles/vim/vimrc.shared` in `~/.vimrc`
- `modify_dot_tmux.conf` — ensures `source-file ~/.dotfiles/tmux/tmux.conf.shared` in `~/.tmux.conf`
- `run_once_before_configure-git-user.sh.tmpl` — sets git user.name/email
- `run_onchange_after_configure-git.sh.tmpl` — sets git include.path/excludesfile
- `run_once_generate-ssh-key.sh.tmpl` — generates SSH key (first run only)

## Architecture

### ZSH Configuration: Shared vs Local

ZSH config is split into shared (in-repo) and local (per-machine) parts:

- **`zsh/zshrc.shared`** (in git) — portable config sourced by all machines
- **`~/.zshrc`** (local, not in git) — machine-specific config (conda, homebrew, gcloud, API keys). Tools like `conda init` write here without dirtying the repo.

The `modify_dot_zshrc` script ensures `source ~/.dotfiles/zsh/zshrc.shared` is present in `~/.zshrc` without overwriting local additions.

### ZSH Shared Config Loading Order

`zsh/zshrc.shared` sources files in this sequence:

1. `zsh/functions.sh` - PATH manipulation functions (path_remove, path_append, path_prepend)
2. `zsh/plugins_before.zsh` - Pre-initialization plugins (zsh-completions, zsh-autosuggestions)
3. `zsh/settings.zsh` - Core zsh settings (completion, history, vim keybindings)
4. `zsh/aliases.sh` - Aliases and shell functions
5. `zsh/prompt.zsh` - Prompt configuration
6. `zsh/plugins_after.zsh` - Post-initialization plugins (zsh-syntax-highlighting, dircolors)

### Vim Plugin Management

Uses Pathogen for plugin management. Plugins are defined in `.chezmoiexternal.toml` and deployed to `vim/bundle/`:
- lightline.vim - statusline
- nerdtree - file explorer
- nerdcommenter - commenting utilities
- vim-colors-solarized - color scheme
- vim-cpp-modern - C++ syntax highlighting

### External Dependencies

All external plugins are managed via `.chezmoiexternal.toml` as GitHub archive downloads pinned to specific commit hashes. To update a plugin version, change the commit hash in the URL.

## Key Customizations

**ZSH keybindings:**
- Vi-style line editing (`bindkey -v`)
- Ctrl-R for incremental search
- Menu completion with hjkl navigation

**Vim keybindings:**
- Leader-n: Toggle NERDTree
- Leader-f: Find current file in NERDTree
- Ctrl-hjkl: Window navigation
- H/L: Line beginning/end

**Shell functions in zsh/aliases.sh:**
- `mcd DIR` - mkdir and cd
- `up [N]` - go up N directories
- `xin DIR CMD...` - execute command in directory
- `cdgr` - cd to git root
- `dfu` - update dotfiles from remote

## File Organization

- `dot_dotfiles/git/` - Global git configuration and ignore patterns
- `dot_dotfiles/shell/` - Shell plugins (dircolors-solarized via external)
- `dot_dotfiles/tmux/` - Tmux configuration and plugins (tmux-prefix-highlight via external)
- `dot_dotfiles/vim/` - Vim configuration, plugins (via external), and file-type settings
- `dot_dotfiles/zsh/` - Zsh configuration files and plugins (via external)

## Important Notes

- Chezmoi deploys config to `~/.dotfiles/` — all internal paths reference this location
- Machine-specific config (API keys, conda, homebrew paths) belongs in `~/.zshrc`, not in the repo
- The config is set up for macOS (darwin) and Linux compatibility with OS-specific checks
- The chezmoi source directory is at `~/.local/share/chezmoi/`
