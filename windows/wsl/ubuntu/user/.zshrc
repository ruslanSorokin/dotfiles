# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update 'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard 'pc'

# Don't start tmux.
zstyle ':z4h:' start-tmux 'no'
# zstyle ':z4h:' prompt-at-bottom 'yes'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs yes

# Rebind Tab in fzf from up to repeat:
zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv' enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1' enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*' enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Start ssh-agent if it's not running yet.
zstyle ':z4h:ssh-agent:' start yes

zstyle ':z4h:*' fzf-flags --color=hl:166,hl+:166

zstyle ':z4h:fzf-complete' fzf-bindings ctrl-k:up tab:repeat
zstyle ':z4h:*' fzf-bindings ctrl-k:up tab:accept

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Define key bindings.
z4h bindkey z4h-backward-kill-word Ctrl+Backspace Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab # undo the last command line change
z4h bindkey redo Alt+/            # redo the last undone command line change

z4h bindkey z4h-cd-back Alt+Left     # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right # cd into the next directory
z4h bindkey z4h-cd-up Alt+Up         # cd into the parent directory
z4h bindkey z4h-cd-down Alt+Down     # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() {
  [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1"
}
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots # no special treatment for file names with a leading dot
# setopt no_auto_menu    # require an extra TAB press to open the completion menu
setopt auto_menu # open completion menu with first TAB

# ==============================================================================
# User configuration
# ==============================================================================

# brew/zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit && compinit

# Windows/WSL: use windows browser
if [ -f /proc/version ]; then
  if grep -qi microsoft /proc/version; then

    export BROWSER='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
    alias open='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
  fi
fi

# pbcopy/pbpaste using xclip
if [[ ! "$OSTYPE" =~ 'darwin' ]]; then
  if type xclip &>/dev/null; then
    # pbcopy using xclip
    alias pbcopy='xclip -selection clipboard'
    # pbpaste using xclip
    alias pbpaste='xclip -selection clipboard -o'
  fi
fi

# ls using exa
if type eza &>/dev/null; then
  alias ls='exa'
  alias ll='eza -l'
  alias l='eza --all --long'
fi

# brew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_GITHUB_API_TOKEN=$(pass show personal/github/token/homebrew)

# docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# zsh completions
#
# make completions case-insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden'
export FZF_DEFAULT_OPTS="--height 100% \
--bind \
ctrl-i:accept,\
ctrl-t:half-page-up,\
ctrl-g:half-page-down,\
ctrl-r:preview-half-page-up,\
ctrl-f:preview-half-page-down,\
ctrl-b:backward-word,\
ctrl-n:forward-word,\
ctrl-o:backward-char,\
ctrl-p:forward-char,\
ctrl-a:backward-kill-word,\
ctrl-z:kill-word \
--ansi"

export FZF_CTRL_T_COMMAND="fd --type f --exclude={.git,.idea,.vscode,.sass-cache,node_modules} --hidden"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"

export FZF_ALT_C_COMMAND="fd --type d . --exclude={.git,.idea,.vscode,.sass-cache,node_modules} --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C --dirsfirst {} -L 5'"

# fzf-tab
#
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'tree -C --dirsfirst -L 5 $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore|rm):*' fzf-preview 'git diff $word | delta'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# accept on tab
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zsh-config/bindings.zsh ] && source ~/.zsh-config/bindings.zsh
[ -f ~/.zsh-config/utils.zsh ] && source ~/.zsh-config/utils.zsh

# zsh-syntax-highlighting theme
[ -f ~/.zsh-config/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh ] && source ~/.zsh-config/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

