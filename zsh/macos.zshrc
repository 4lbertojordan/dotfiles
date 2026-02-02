# --- 1. Initialize Homebrew (M1 Silicon) ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- 2. History configuration ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# --- 3. Autocomplete (Completions) ---
# Add all completions paths BEFORE compinit
fpath=(
  $(brew --prefix)/share/zsh-completions
  ~/.docker/completions
  /Users/albertojordan/.docker/completions
  $fpath
)

# Initialize compinit only once
# -i ignores insecure directories, -u uses them without asking (choose whichever you prefer)
autoload -Uz compinit
compinit -u

# --- 4. Visual menu styles ---
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true

# --- 5. Plugins ---
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- 6. Keyboard shortcuts ---
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# --- FZF (Smart Search) ---
if [ -d "$(brew --prefix)/opt/fzf" ]; then
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh" 2> /dev/null
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" 2> /dev/null
fi

# --- Modern tools ---
eval "$(zoxide init zsh)"

# Modern aliases
alias ls="eza --icons=auto"
alias ll="eza --icons=auto --long --git"
alias la="eza --icons=auto --long --all"
alias lt="eza --icons=auto --tree --level=2"
alias lg="lazygit"

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

# --- PATH EXPORTS ---
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export PATH=$PATH:~/.docker/bin

# --- Starship Prompt ---
eval "$(starship init zsh)"