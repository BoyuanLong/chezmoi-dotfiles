# External plugins (initialized after)

# fzf-git.sh (git helpers for fzf, must be before syntax highlighting)
if [[ -f ~/.dotfiles/zsh/plugins/fzf-git.sh/fzf-git.sh ]]; then
    source ~/.dotfiles/zsh/plugins/fzf-git.sh/fzf-git.sh
fi

# Syntax highlighting
source ~/.dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# Syntax highlighting colors — uses ANSI names so the terminal's
# Solarized preset provides the actual color values.
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=cyan
ZSH_HIGHLIGHT_STYLES[path]=fg=yellow,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[assign]=fg=cyan

# dircolors
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ "$(tput colors)" -ge "256" ]]; then
       eval $(dircolors =(cat ~/.dotfiles/shell/plugins/dircolors-solarized/dircolors.256dark ~/.dotfiles/shell/dircolors.extra))
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export CLICOLOR=1
    export LSCOLORS=exfxfeaebxxehehbadacea
fi

