bindkey -e
export EDITOR=vim

export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH

# Alias
alias ls='ls -G'
alias diff='colordiff'
alias ll='ls -G -A -h -l -F'
alias gvim='open -a MacVim'
alias adobe='open -a Adobe\ Reader'
alias adblayout='adb shell setprop debug.layout'
alias hugon='hugo new --editor="code"'

HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
autoload -U compinit
compinit
setopt auto_cd
setopt correct
setopt auto_list
setopt always_to_end
setopt nonomatch

# ignorecase, but smartcase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
autoload colors
colors
PROMPT="%{${fg[yellow]}%}%~%{${fg[cyan]}%} %(!.#.$) %{${reset_color}%}"

# brew install zsh-syntax-highlighting
if [ -e $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# brew install zsh-completions
if [ -e $(brew --prefix)/share/zsh-completions ]; then
    fpath=($(brew --prefix)/share/zsh-completions $fpath)
fi

# Git
autoload -Uz vcs_info
# %b branch
# %a action
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
# Display the branch if it's managed by Git
RPROMPT="%1(v|%F{green}%1v%f|)"

# Update PATH for the Google Cloud SDK.
if [ -f "$HOME/etc/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/etc/google-cloud-sdk/path.zsh.inc"; fi

# Enable shell command completion for gcloud.
if [ -f "$HOME/etc/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/etc/google-cloud-sdk/completion.zsh.inc"; fi
