# External plugins (initialized before)

# zsh-completions
fpath=(~/.dotfiles/zsh/plugins/zsh-completions/src $fpath)

zstyle ':completion:*' matcher-list '' '+m:{a-zA-Z}={A-Za-z}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'

# zsh-autosuggestions
source ~/.dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=241"
# bindkey '^m' autosuggest-accept
# bindkey '^o' autosuggest-execute

# zsh-you-should-use (reminds you of existing aliases)
source ~/.dotfiles/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# zsh-autopair (auto-close brackets/quotes)
source ~/.dotfiles/zsh/plugins/zsh-autopair/autopair.zsh

# zsh-history-substring-search (fish-style up/down arrow history)
source ~/.dotfiles/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
