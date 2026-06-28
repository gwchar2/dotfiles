# General
alias c='clear'
alias e='exit'
alias reload='source ~/.zshrc'

# Portable command names
if command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
  alias cat='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

if command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi

# Files
alias ls='eza --all --icons=always --group-directories-first'
alias ll='eza --all --long --icons=always --git --group-directories-first'
alias tree='eza --tree --icons=always'

# Navigation
alias dot='cd ~/dotfiles'
alias ref='cd ~/references/dotfiles-main'

# Git
alias g='git'
alias gs='git status'
alias gss='git status -s'
alias ga='git add'
alias gd='git diff'
alias gds='git diff --staged'
alias gc='git commit'
alias gcm='git commit -m'
alias gl='git log --oneline --graph --decorate -10'
alias gb='git branch'
alias gco='git checkout'
alias gp='git push'
alias gpl='git pull'

# Tools
alias v='nvim'
alias vi='nvim'
alias y='yazi'
alias cx='codex'
