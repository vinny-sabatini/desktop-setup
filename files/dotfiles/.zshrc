# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/home/vinnysabatini/.oh-my-zsh/custom

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  gh
  git
  git-prompt
  kube-ps1
  oc
  pip
  podman
  poetry
  themes
  virtualenv
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

# Vinny's Customizations
set -o vi

export TECH_DIR=$HOME/tech         # top level dir for locally installed software
export BIN_DIR=$TECH_DIR/bin       # directory for scripts, binaries, etc.
export MAN_DIR=$TECH_DIR/share/man # directory for man pages
export PROJ_DIR=$HOME/projects     # directory for code projects
export VISUAL=vim                 # vim is my editor
export EDITOR=vim                 # vim is my editor
export HOSTNAME=$(hostname -s)     # Short hostname of this computer
export GOPATH=$PROJ_DIR/go
#export GOROOT=$TECH_DIR/go
export KIND_EXPERIMENTAL_PROVIDER=podman
export KIND_INGRESS_CONFIG=$HOME/.config/kind-ingress.yaml

# Generic Aliases
alias cat='bat'
alias ll='ls -l'
alias la='ls -A'
alias ltr='ls -ltr'
alias vi='vim'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias mkdir='mkdir -p'
alias df='df -h'
alias bin='cd $BIN_DIR'
alias tech='cd $TECH_DIR'
alias cd..='cd ..'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../../..'
alias docker=podman
alias k=kubectl
alias t=talosctl
alias o=oc
alias krew="kubectl krew"
alias netshoot="kubectl run netshoot --image=nicolaka/netshoot -i --tty --rm"

# PATH
# The bottom of this list will be at the beginning of PATH
# The top of this list will be at the end of PATH
local paths=(
    /usr/local/bin
    #$GOROOT/bin
    $GOPATH/bin
    $HOME/.vim/bin
    $HOME/.krew/bin
    $BIN_DIR
)

for DIR in $paths; do
    if [[ -d $DIR ]]; then
        if [[ ! $PATH =~ $DIR ]]; then
            PATH=$DIR:$PATH
        fi
    fi
done

### FUNCTIONS ###
venv() {
    virtualenv .venv --$1
    if [[ !$(grep python .venv/pyvenv.cfg) ]] ; then
        echo "prompt = ${PWD##*/}" >> .venv/pyvenv.cfg
    fi
    source .venv/bin/activate
}

checkport() {
    timeout 1 bash -c "cat < /dev/null > /dev/tcp/$1/$2"
    echo $?
}
### END FUNCTIONS ###
#

### COMPLETION ###
### Kubernetes Setup ###
if which kubectl > /dev/null 2>&1; then
    source <(kubectl completion zsh)
    alias k='kubectl'
    complete -F __start_kubectl k

    # Setup kubectx
    alias kctx='kubectl ctx'
    alias kubectx=kctx

    # Setup kubens
    alias kns='kubectl ns'
    alias kubens=kns
fi


### OpenShift Setup ###
if which oc > /dev/null 2>&1; then
    source <(oc completion zsh)
    alias o='oc'
    complete -F __start_oc o
fi

# Enable crc autocomplete
if which crc > /dev/null 2>&1; then
    source <(crc completion zsh)
fi

# Enable s2i autocomplete
if which s2i > /dev/null 2>&1; then
    source <(s2i completion zsh)
fi

# Enable gh autocomplete
if which gh > /dev/null 2>&1; then
    eval "$(gh completion -s zsh)"
fi

# Enable pack autocomplete
if which pack > /dev/null 2>&1; then
    . $(pack completion)
fi

# Enable ag auto complete
if [ -f "$BASH_INCLUDE_DIR/ag.bashcomp.sh" ]; then
    #. $BASH_INCLUDE_DIR/ag.bashcomp.sh
fi

# Enable gcloud complete
if which gcloud > /dev/null 2>&1; then
    source /usr/lib64/google-cloud-sdk/completion.zsh.inc
fi

if which kind > /dev/null 2>&1; then
    eval $(kind completion zsh)
fi

if which talosctl > /dev/null 2>&1; then
    source <(talosctl completion zsh)
fi

if which cilium > /dev/null 2>&1; then
    source <(cilium completion zsh)
fi

if which argocd > /dev/null 2>&1; then
    source <(argocd completion zsh)
    compdef _argocd argocd
fi

complete -C $HOME/projects/go/bin/odo odo

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault
