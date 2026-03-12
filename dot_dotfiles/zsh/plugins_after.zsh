# External plugins (initialized after)

# fzf-git.sh (git helpers for fzf, must be before syntax highlighting)
if [[ -f ~/.dotfiles/zsh/plugins/fzf-git.sh/fzf-git.sh ]]; then
    source ~/.dotfiles/zsh/plugins/fzf-git.sh/fzf-git.sh
fi

# Syntax highlighting
source ~/.dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# Syntax highlighting colors — uses Solarized 256-color codes so
# colors render correctly regardless of the terminal's ANSI palette.
# Solarized mappings: green=64, red=160, cyan=37, yellow=136,
#                     blue=33, magenta=125, violet=61, orange=166
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=160
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=37,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=64,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=64,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=64,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=64,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=64,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=37
ZSH_HIGHLIGHT_STYLES[path]=fg=136,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=33
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=125,bold
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=125,bold
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=136
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=136
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=136
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=136
ZSH_HIGHLIGHT_STYLES[assign]=fg=37

# dircolors
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ "$(tput colors)" -ge "256" ]]; then
       eval $(dircolors =(cat ~/.dotfiles/shell/plugins/dircolors-solarized/dircolors.256dark ~/.dotfiles/shell/dircolors.extra))
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export CLICOLOR=1
    export LSCOLORS=exfxfeaebxxehehbadacea
fi

