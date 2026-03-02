# Chezmoi Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/). Configurations for **zsh**, **vim**, **tmux**, and **git** with 24 auto-installed plugins.

## Setup on a New Machine

### 1. Install chezmoi

**macOS:**

```bash
brew install chezmoi
```

**Linux:**

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### 2. Initialize and apply

```bash
chezmoi init --apply BoyuanLong/chezmoi-dotfiles
```

You'll be prompted for your **git name** and **email**. After that, everything is automatic.

### 3. What happens during setup

Chezmoi runs these steps in order:

1. **Prompts for git credentials** — your name and email are saved to `~/.config/chezmoi/chezmoi.toml` and reused by setup scripts
2. **Deploys config files** — all configs are placed in `~/.dotfiles/`
3. **Creates symlink** — `~/.vim` → `~/.dotfiles/vim`
4. **Sources shared configs** — adds `source` lines to `~/.zshrc`, `~/.vimrc`, and `~/.tmux.conf` (existing content is preserved)
5. **Downloads plugins** — 24 plugin archives (zsh, vim, tmux, dircolors) fetched from GitHub
6. **Configures git** — sets `user.name`, `user.email`, `core.excludesfile`, and includes shared aliases
7. **Generates SSH key** — creates an ed25519 key (or RSA fallback) if none exists
8. **Installs binaries** — installs `fzf`, `zoxide`, and `ripgrep` via brew (macOS) or apt/dnf (Linux)
9. **Installs tmux plugins** — runs TPM plugin install

### 4. Start a new shell

```bash
exec zsh
```

## Prerequisites

These should be installed before or alongside chezmoi:

| Tool | Required | Notes |
|------|----------|-------|
| **zsh** | Yes | Must be your default shell (`chsh -s $(which zsh)`) |
| **git** | Yes | Needed for chezmoi init |
| **curl** | Yes | For chezmoi install (if not using brew) |
| **tmux** | Recommended | Configs are applied but tmux itself isn't auto-installed |
| **vim** | Recommended | Configs are applied but vim itself isn't auto-installed |

The setup scripts will auto-install **fzf**, **zoxide**, and **ripgrep** if they're missing.

## What's Included

### Zsh

- Vi-style keybindings with Ctrl-R fuzzy history search
- Tab completion powered by fzf-tab
- Autosuggestions, syntax highlighting, and autopair
- History substring search (Up/Down arrows)
- Alias reminders (zsh-you-should-use)
- Custom async prompt with git branch, status, ahead/behind counts
- Prompt modes toggled with `tog` (full → 1-level → minimal → empty)

### Vim

- Pathogen plugin manager with 11 plugins auto-installed
- Solarized dark color scheme with lightline statusline
- NERDTree file explorer (`<Leader>n`)
- Fuzzy file/buffer/search via fzf (`<Leader>p`, `<Leader>b`, `<Leader>rg`)
- Git integration (fugitive), linting (ALE), and surround
- Persistent undo, relative line numbers, mouse support

### Tmux

- Prefix: `Ctrl-a` (with `Ctrl-b` fallback)
- Vim-style copy mode and pane navigation
- Session save/restore (resurrect + continuum)
- Solarized colors with prefix highlight indicator
- 7 TPM plugins auto-installed

### Git

- Short aliases (`st`, `di`, `lg`, `br`, `ci`, `ca`, etc.)
- Pretty graph log formats (`gr`, `gra`)
- Solarized grep colors
- Global gitignore for OS/IDE artifacts

## Day-to-Day Usage

### Pull latest dotfiles

```bash
dfu
```

This is an alias for `chezmoi update` — it pulls from remote and applies changes.

### Edit a config file

```bash
chezmoi edit ~/.dotfiles/zsh/aliases.sh    # open the source in your editor
chezmoi diff                                # preview changes
chezmoi apply -v                            # deploy to ~/
```

### Commit and push changes

```bash
cd ~/.local/share/chezmoi
git add -A && git commit -m "description of changes" && git push
```

### Update a plugin version

Edit `.chezmoiexternal.toml` — change the commit hash in the plugin's archive URL, then run `chezmoi apply`.

## Useful Aliases and Functions

| Command | Description |
|---------|-------------|
| `ll` | `ls -lah` |
| `dfu` | Pull and apply dotfiles (`chezmoi update`) |
| `zshu` | Reload zsh config (`source ~/.zshrc`) |
| `cdgr` | cd to git repo root |
| `mcd DIR` | Create directory and cd into it |
| `up [N]` | Go up N directories (default 1) |

## Vim Key Bindings

| Key | Action |
|-----|--------|
| `<Leader>n` | Toggle NERDTree |
| `<Leader>p` | Fuzzy file finder |
| `<Leader>b` | Buffer list |
| `<Leader>rg` | Ripgrep search |
| `<Leader>gs` | Git status |
| `<Leader>u` | Toggle undo tree |
| `Ctrl-h/j/k/l` | Window navigation |

## Layout

```
.
├── .chezmoi.toml.tmpl          # Config template (prompts for name/email)
├── .chezmoiexternal.toml       # 24 plugin archive definitions
├── symlink_dot_vim             # Creates ~/.vim → ~/.dotfiles/vim
├── modify_dot_zshrc            # Ensures source line in ~/.zshrc
├── modify_dot_vimrc            # Ensures source line in ~/.vimrc
├── modify_dot_tmux.conf        # Ensures source line in ~/.tmux.conf
├── run_once_before_configure-git-user.sh.tmpl
├── run_once_generate-ssh-key.sh.tmpl
├── run_onchange_after_configure-git.sh.tmpl
├── run_onchange_after_install-binaries.sh.tmpl
├── run_onchange_after_install-tmux-plugins.sh.tmpl
└── dot_dotfiles/               # Deploys to ~/.dotfiles/
    ├── git/                    # gitconfig, gitignore_global
    ├── zsh/                    # zshrc.shared, aliases, prompt, plugins
    ├── vim/                    # vimrc.shared, autoload, ftdetect, ftplugin
    ├── tmux/                   # tmux.conf.shared
    └── shell/                  # dircolors
```

## Customization

Your local `~/.zshrc`, `~/.vimrc`, and `~/.tmux.conf` are not overwritten — the modify scripts only prepend a `source` line. Add machine-specific config below that line and it will persist across `chezmoi apply` runs.
