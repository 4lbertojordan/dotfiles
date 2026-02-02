# --- 1. Initialize Homebrew (IMPORTANT: This goes first) ---
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- 2. History configuration (So search works) ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between terminals
setopt HIST_IGNORE_DUPS       # Ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS   # Ignore older duplicates
setopt HIST_REDUCE_BLANKS     # Remove extra spaces
setopt INC_APPEND_HISTORY     # Save the command as soon as you press enter

# --- 3. Autocomplete (Completions) ---
# Add brew completions to Zsh path
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit

# --- 4. Visual menu styles (Restored from original) ---
# This lets you use TAB to select with arrows and see colors
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Ignore case
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Use ls colors
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true

# --- 5. Plugins (Load after compinit) ---
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- 6. Keyboard shortcuts ---
bindkey -e  # Ensure Emacs mode (default). Ctrl+R search, Ctrl+A home, etc.
# Up/down arrow keys search history for what you already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# --- FZF (Smart Search) ---
# This enables Ctrl+R (history) and Ctrl+T (files) with a visual finder
if [ -d "$(brew --prefix)/opt/fzf" ]; then
  # Load autocomplete
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh" 2> /dev/null
  # Load key bindings
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" 2> /dev/null
fi

# --- Modern tools ---

# Initialize Zoxide (better than cd)
eval "$(zoxide init zsh)"

# Alias to use Eza instead of ls
alias ls="eza --icons=auto"
alias ll="eza --icons=auto --long --git"  # Detailed list with git
alias la="eza --icons=auto --long --all"  # Includes hidden
alias lt="eza --icons=auto --tree --level=2" # Show tree structure

# --- ALIASES AND FUNCTIONS ---
alias cdc="cd $HOME/Documents/workspace"
alias k="kubectl"
alias pod="kubectl get pods"
alias svc="kubectl get svc"
alias k8clean="export KUBECONFIG=$KUBECONFIG_SAVED"
alias kubernetes="export KUBECONFIG=$HOME/workspace/kubernetes/main.yaml"
alias d="docker"
alias dc="docker compose"

function pull { git pull; }
function push { git push; }
function gac { git add . && git commit -m "$1" -a; }
function gc {
  git add -A
  if [ -z "$1" ]; then
    git commit -S
  else
    git commit -S -m "$1"
  fi
}

# VPN
alias vpn-up="wg-quick up wg0"
alias vpn-down="wg-quick down wg0"

# O.S and applications update:
alias full-update="sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean && brew upgrade"

# --- 7. Starship prompt (At the end) ---
eval "$(starship init zsh)"
export PATH="/home/linuxbrew/.linuxbrew/opt/node@24/bin:$PATH"
