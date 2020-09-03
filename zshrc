# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#PATH=$HOME/local/bin:$HOME/.cargo/bin:$PATH
source $HOME/.zprofile

# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="geoffgarside"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR="nvim"

# Dirs
alias jd='cd $HOME/.julia/dev'

# fzf
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
#export FZF_DEFAULT_COMMAND='
#  (git ls-tree -r --name-only HEAD ||
#   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
#      sed s/^..//) 2> /dev/null'
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

export BROWSER="google-chrome-stable"

# Julia
#export JULIA_REVISE=manual

export JULIA_PATH="$HOME/build/julia/usr"
export LLVM_PATH="$JULIA_PATH/tools"
#export PATH="$LLVM_PATH:$PATH"
export JULIA_NUM_THREADS=4

export JL="$JULIA_PATH/bin/julia"
alias jj="$JL -q"
alias j="$HOME/bin/julia-1.5.1/bin/julia -q"
export OPT="$LLVM_PATH/opt"

export OPTFLAGS="-load=$JULIA_PATH/lib/libjulia.so"

export JLPASSES="-tbaa -PropagateJuliaAddrspaces -simplifycfg -dce -sroa -memcpyopt -always-inline -AllocOpt \
          -instcombine -simplifycfg -sroa -instcombine -jump-threading -instcombine -reassociate \
          -early-cse -AllocOpt -loop-idiom -loop-rotate -LowerSIMDLoop -licm -loop-unswitch \
          -instcombine -indvars -loop-deletion -loop-unroll -AllocOpt -sroa -instcombine -gvn \
          -memcpyopt -sccp -sink -instsimplify -instcombine -jump-threading -dse -AllocOpt \
          -simplifycfg -loop-idiom -loop-deletion -jump-threading -slp-vectorizer -adce \
          -instcombine -loop-vectorize -instcombine -barrier -LowerExcHandlers \
          -GCInvariantVerifier -LateLowerGCFrame -dce -LowerPTLS -simplifycfg -CombineMulAdd"

#set -x JLPASSES_UNTIL_LV -tbaa -PropagateJuliaAddrspaces -simplifycfg -dce -sroa -memcpyopt -always-inline -AllocOpt \
#          -instcombine -simplifycfg -sroa -instcombine -jump-threading -instcombine -reassociate \
#          -early-cse -AllocOpt -loop-idiom -loop-rotate -LowerSIMDLoop -licm \
#          #-loop-unswitch \
#          -instcombine -indvars -loop-deletion -loop-unroll -AllocOpt -sroa -instcombine -gvn \
#          -memcpyopt -sccp -sink -instsimplify -instcombine -jump-threading -dse -AllocOpt \
#          -simplifycfg -loop-idiom -loop-deletion -jump-threading -slp-vectorizer -adce \
#          -instcombine
#
#set -x JLPASSES_NOSLP_NOROTATE -tbaa -PropagateJuliaAddrspaces -simplifycfg -dce -sroa -memcpyopt -always-inline -AllocOpt \
#          -instcombine -simplifycfg -sroa -instcombine -jump-threading -instcombine -reassociate \
#          -early-cse -AllocOpt -loop-idiom -LowerSIMDLoop -licm -loop-unswitch \
#          -instcombine -indvars -loop-deletion -loop-unroll -AllocOpt -sroa -instcombine -gvn \
#          -memcpyopt -sccp -sink -instsimplify -instcombine -jump-threading -dse -AllocOpt \
#          -simplifycfg -loop-idiom -loop-deletion -jump-threading -adce \
#          -instcombine -loop-vectorize -instcombine -barrier -LowerExcHandlers \
#          -GCInvariantVerifier -LateLowerGCFrame -dce -LowerPTLS -simplifycfg -CombineMulAdd

# Misc
alias sv='sudoedit'
alias v='nvim'
alias r='ranger'
alias ls='exa'
alias ll='exa -la --git'
alias l='exa -lah --git'
alias dict='cat /usr/share/dict/words | fzf-tmux -l 20% --multi --reverse'

export MATLAB_LOG_DIR=/tmp

if [[ $DISPLAY ]]; then
    if which tmux >/dev/null 2>&1; then
        #if not inside a tmux session, and if no session is started, start a new session
        test -z "$TMUX" && (tmux attach || tmux new-session)
    fi
fi
