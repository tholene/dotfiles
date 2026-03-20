# ~/.bashrc (Arch)

# Only for interactive shells
[[ $- != *i* ]] && return

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Ensure Git can prompt for credentials in terminal when needed
export GIT_TERMINAL_PROMPT=1

# --- Prompt (dir + git branch, colored; dirty vs clean) ---

# Load official git prompt support (provides __git_ps1)
if [[ -r /usr/share/git/completion/git-prompt.sh ]]; then
  . /usr/share/git/completion/git-prompt.sh
  # Show dirty state info to __git_ps1 via env vars
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
fi

# Helper: set git color based on working tree clean/dirty
__git_color() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
  if git diff --quiet --ignore-submodules -- 2>/dev/null && \
     git diff --cached --quiet --ignore-submodules -- 2>/dev/null; then
    # clean -> yellow
    printf '\[\033[0;33m\]'
  else
    # dirty -> cyan
    printf '\[\033[0;36m\]'
  fi
}

# Format: <dir> <(branch)> $
# Example: wow (main) $
PS1='\[\033[1;32m\]\W\[\033[0m\]$(__git_color)$(__git_ps1 " (%s)")\[\033[1;32m\]\$ \[\033[0m\]'

# --- Completion ---

# System bash completion
if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

# Git completion (tab completion for git)
if [[ -r /usr/share/git/completion/git-completion.bash ]]; then
  . /usr/share/git/completion/git-completion.bash
fi

# --- Node version management (fnm) ---
# Enable auto-switching based on .node-version when you cd
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

# --- Aliases ---
alias c='clear'
alias y='yarn'
alias p='pnpm'
alias blastyarn='rm -rf node_modules && yarn cache clean && yarn'
alias jest='./node_modules/jest/bin/jest.js'
alias sublime='subl'
alias recentb='npx git-recent-branch'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Quick edits
alias editbash='${EDITOR:-nano} ~/.bashrc'
alias sourcebash='source ~/.bashrc && echo "Sourced ~/.bashrc!"'
alias editgit='${EDITOR:-nano} ~/.gitconfig'

# Prefer a sensible default editor (optional; change to subl if you want)
export EDITOR=webstorm

# JetBrains Toolbox scripts (Linux path; only add if it exists)
if [[ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ]]; then
  export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
fi