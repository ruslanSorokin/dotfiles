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
# ZSH_THEME="macos-zsh-theme/macos-theme"
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
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autoupdate
  docker
  git-auto-fetch
  gitfast
  zsh-syntax-highlighting
)

# brew/zsh-completion
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

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

# export redirecting to Windows browser only if it is WSL
if grep -qi microsoft /proc/version; then
  export BROWSER='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
  alias open='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
fi


# brew/zsh-compelitions export
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit && compinit
fi


# zsh-completions case-insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'


# zsh-syntax-highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f14c4c,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='none'
ZSH_HIGHLIGHT_STYLES[command]='none'
ZSH_HIGHLIGHT_STYLES[alias]='none'
ZSH_HIGHLIGHT_STYLES[function]='none'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#F57C00,bold'

# git-auto-fetch configuration
GIT_AUTO_FETCH_INTERVAL=30

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# # gnugpg export
# export GPG_TTY=$(tty)

export GPG_TTY=$TTY

# brew no auto update
export HOMEBREW_NO_AUTO_UPDATE=1
# brew github api token
export HOMEBREW_GITHUB_API_TOKEN=$(pass show personal/github/homebrew_token)


# Docker buildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# fzf configuration
export FZF_DEFAULT_COMMAND='fd'


# zsh-completions
# Ctrl + Space
bindkey '^ ' menu-complete
# Tab
bindkey '^I' complete-word


# ls using exa
alias ls='exa'

# pbcopy using xclip
alias pbcopy='xclip -selection clipboard'
# pbpaste using xclip
alias pbpaste='xclip -selection clipboard -o'


# ls command colorization
export LS_COLORS="bd=0;38;2;102;217;239;48;2;51;51;51:rs=0:mi=0;38;2;0;0;0;48;2;255;74;68:do=0;38;2;0;0;0;48;2;249;38;114:di=0;38;2;102;217;239:ln=0;38;2;249;38;114:ow=0:fi=0:ca=0:no=0:pi=0;38;2;0;0;0;48;2;102;217;239:st=0:so=0;38;2;0;0;0;48;2;249;38;114:sg=0:su=0:ex=1;38;2;249;38;114:cd=0;38;2;249;38;114;48;2;51;51;51:or=0;38;2;0;0;0;48;2;255;74;68:tw=0:mh=0:*~=0;38;2;122;112;112:*.m=0;38;2;0;255;135:*.z=4;38;2;249;38;114:*.d=0;38;2;0;255;135:*.h=0;38;2;0;255;135:*.o=0;38;2;122;112;112:*.p=0;38;2;0;255;135:*.t=0;38;2;0;255;135:*.a=1;38;2;249;38;114:*.r=0;38;2;0;255;135:*.c=0;38;2;0;255;135:*.pl=0;38;2;0;255;135:*.la=0;38;2;122;112;112:*.di=0;38;2;0;255;135:*.ml=0;38;2;0;255;135:*.md=0;38;2;226;209;57:*.hi=0;38;2;122;112;112:*.jl=0;38;2;0;255;135:*.wv=0;38;2;253;151;31:*.bz=4;38;2;249;38;114:*.cc=0;38;2;0;255;135:*.mn=0;38;2;0;255;135:*.bc=0;38;2;122;112;112:*.hh=0;38;2;0;255;135:*.ex=0;38;2;0;255;135:*.rb=0;38;2;0;255;135:*.rs=0;38;2;0;255;135:*.7z=4;38;2;249;38;114:*.td=0;38;2;0;255;135:*.pp=0;38;2;0;255;135:*.ui=0;38;2;166;226;46:*.sh=0;38;2;0;255;135:*.kt=0;38;2;0;255;135:*.lo=0;38;2;122;112;112:*.gv=0;38;2;0;255;135:*.cr=0;38;2;0;255;135:*.py=0;38;2;0;255;135:*.fs=0;38;2;0;255;135:*.so=1;38;2;249;38;114:*.ll=0;38;2;0;255;135:*css=0;38;2;0;255;135:*.ps=0;38;2;230;219;116:*.cp=0;38;2;0;255;135:*.gz=4;38;2;249;38;114:*.el=0;38;2;0;255;135:*.vb=0;38;2;0;255;135:*.pm=0;38;2;0;255;135:*.js=0;38;2;0;255;135:*.go=0;38;2;0;255;135:*.hs=0;38;2;0;255;135:*.ts=0;38;2;0;255;135:*.as=0;38;2;0;255;135:*.ko=1;38;2;249;38;114:*.xz=4;38;2;249;38;114:*.rm=0;38;2;253;151;31:*.cs=0;38;2;0;255;135:*.nb=0;38;2;0;255;135:*.rtf=0;38;2;230;219;116:*.com=1;38;2;249;38;114:*.tmp=0;38;2;122;112;112:*.bak=0;38;2;122;112;112:*.img=4;38;2;249;38;114:*.dll=1;38;2;249;38;114:*.git=0;38;2;122;112;112:*.exe=1;38;2;249;38;114:*.xls=0;38;2;230;219;116:*.bcf=0;38;2;122;112;112:*.xml=0;38;2;226;209;57:*.lua=0;38;2;0;255;135:*.sxi=0;38;2;230;219;116:*.ics=0;38;2;230;219;116:*.psd=0;38;2;253;151;31:*.php=0;38;2;0;255;135:*.m4v=0;38;2;253;151;31:*.nix=0;38;2;166;226;46:*TODO=1:*.tcl=0;38;2;0;255;135:*.mp4=0;38;2;253;151;31:*.tex=0;38;2;0;255;135:*.ttf=0;38;2;253;151;31:*.ppt=0;38;2;230;219;116:*.xlr=0;38;2;230;219;116:*.tif=0;38;2;253;151;31:*.hxx=0;38;2;0;255;135:*.gvy=0;38;2;0;255;135:*.pod=0;38;2;0;255;135:*.deb=4;38;2;249;38;114:*.mid=0;38;2;253;151;31:*.clj=0;38;2;0;255;135:*.gif=0;38;2;253;151;31:*.fls=0;38;2;122;112;112:*.ind=0;38;2;122;112;112:*.dpr=0;38;2;0;255;135:*.kts=0;38;2;0;255;135:*.eps=0;38;2;253;151;31:*.png=0;38;2;253;151;31:*.blg=0;38;2;122;112;112:*.vob=0;38;2;253;151;31:*.bin=4;38;2;249;38;114:*.bag=4;38;2;249;38;114:*.pas=0;38;2;0;255;135:*.pro=0;38;2;166;226;46:*.txt=0;38;2;226;209;57:*.vim=0;38;2;0;255;135:*.svg=0;38;2;253;151;31:*.ods=0;38;2;230;219;116:*.ipp=0;38;2;0;255;135:*.epp=0;38;2;0;255;135:*.def=0;38;2;0;255;135:*.awk=0;38;2;0;255;135:*.pgm=0;38;2;253;151;31:*.cxx=0;38;2;0;255;135:*.ini=0;38;2;166;226;46:*.wav=0;38;2;253;151;31:*.kex=0;38;2;230;219;116:*.rpm=4;38;2;249;38;114:*.mpg=0;38;2;253;151;31:*.tar=4;38;2;249;38;114:*.rar=4;38;2;249;38;114:*.jar=4;38;2;249;38;114:*.pyd=0;38;2;122;112;112:*.xcf=0;38;2;253;151;31:*.tbz=4;38;2;249;38;114:*.bmp=0;38;2;253;151;31:*.zst=4;38;2;249;38;114:*.dot=0;38;2;0;255;135:*.sxw=0;38;2;230;219;116:*.apk=4;38;2;249;38;114:*.ilg=0;38;2;122;112;112:*.wmv=0;38;2;253;151;31:*.odp=0;38;2;230;219;116:*.xmp=0;38;2;166;226;46:*.pid=0;38;2;122;112;112:*.bz2=4;38;2;249;38;114:*.cpp=0;38;2;0;255;135:*hgrc=0;38;2;166;226;46:*.pbm=0;38;2;253;151;31:*.swp=0;38;2;122;112;112:*.fsi=0;38;2;0;255;135:*.htc=0;38;2;0;255;135:*.cgi=0;38;2;0;255;135:*.toc=0;38;2;122;112;112:*.rst=0;38;2;226;209;57:*.ltx=0;38;2;0;255;135:*.csx=0;38;2;0;255;135:*.pkg=4;38;2;249;38;114:*.fnt=0;38;2;253;151;31:*.tml=0;38;2;166;226;46:*.htm=0;38;2;226;209;57:*.aux=0;38;2;122;112;112:*.mov=0;38;2;253;151;31:*.bib=0;38;2;166;226;46:*.ogg=0;38;2;253;151;31:*.mkv=0;38;2;253;151;31:*.sbt=0;38;2;0;255;135:*.bbl=0;38;2;122;112;112:*.tgz=4;38;2;249;38;114:*.asa=0;38;2;0;255;135:*.cfg=0;38;2;166;226;46:*.bsh=0;38;2;0;255;135:*.mir=0;38;2;0;255;135:*.bst=0;38;2;166;226;46:*.mli=0;38;2;0;255;135:*.odt=0;38;2;230;219;116:*.zip=4;38;2;249;38;114:*.erl=0;38;2;0;255;135:*.vcd=4;38;2;249;38;114:*.pdf=0;38;2;230;219;116:*.yml=0;38;2;166;226;46:*.wma=0;38;2;253;151;31:*.avi=0;38;2;253;151;31:*.inl=0;38;2;0;255;135:*.log=0;38;2;122;112;112:*.bat=1;38;2;249;38;114:*.hpp=0;38;2;0;255;135:*.otf=0;38;2;253;151;31:*.pyc=0;38;2;122;112;112:*.zsh=0;38;2;0;255;135:*.exs=0;38;2;0;255;135:*.jpg=0;38;2;253;151;31:*.dox=0;38;2;166;226;46:*.tsx=0;38;2;0;255;135:*.c++=0;38;2;0;255;135:*.fon=0;38;2;253;151;31:*.pyo=0;38;2;122;112;112:*.csv=0;38;2;226;209;57:*.mp3=0;38;2;253;151;31:*.ppm=0;38;2;253;151;31:*.doc=0;38;2;230;219;116:*.pps=0;38;2;230;219;116:*.arj=4;38;2;249;38;114:*.iso=4;38;2;249;38;114:*.m4a=0;38;2;253;151;31:*.idx=0;38;2;122;112;112:*.ps1=0;38;2;0;255;135:*.out=0;38;2;122;112;112:*.sql=0;38;2;0;255;135:*.inc=0;38;2;0;255;135:*.sty=0;38;2;122;112;112:*.elm=0;38;2;0;255;135:*.dmg=4;38;2;249;38;114:*.aif=0;38;2;253;151;31:*.h++=0;38;2;0;255;135:*.fsx=0;38;2;0;255;135:*.ico=0;38;2;253;151;31:*.flv=0;38;2;253;151;31:*.swf=0;38;2;253;151;31:*.docx=0;38;2;230;219;116:*.yaml=0;38;2;166;226;46:*.pptx=0;38;2;230;219;116:*.flac=0;38;2;253;151;31:*.rlib=0;38;2;122;112;112:*.purs=0;38;2;0;255;135:*.opus=0;38;2;253;151;31:*.epub=0;38;2;230;219;116:*.json=0;38;2;166;226;46:*.bash=0;38;2;0;255;135:*.hgrc=0;38;2;166;226;46:*.tiff=0;38;2;253;151;31:*.java=0;38;2;0;255;135:*.xlsx=0;38;2;230;219;116:*.less=0;38;2;0;255;135:*.dart=0;38;2;0;255;135:*.webm=0;38;2;253;151;31:*.lock=0;38;2;122;112;112:*.html=0;38;2;226;209;57:*.mpeg=0;38;2;253;151;31:*.psm1=0;38;2;0;255;135:*.conf=0;38;2;166;226;46:*.psd1=0;38;2;0;255;135:*.diff=0;38;2;0;255;135:*.h264=0;38;2;253;151;31:*.make=0;38;2;166;226;46:*.toml=0;38;2;166;226;46:*.lisp=0;38;2;0;255;135:*.fish=0;38;2;0;255;135:*.tbz2=4;38;2;249;38;114:*.orig=0;38;2;122;112;112:*.jpeg=0;38;2;253;151;31:*.mdown=0;38;2;226;209;57:*.cmake=0;38;2;166;226;46:*.swift=0;38;2;0;255;135:*.xhtml=0;38;2;226;209;57:*.dyn_o=0;38;2;122;112;112:*.class=0;38;2;122;112;112:*.cabal=0;38;2;0;255;135:*passwd=0;38;2;166;226;46:*README=0;38;2;0;0;0;48;2;230;219;116:*.toast=4;38;2;249;38;114:*shadow=0;38;2;166;226;46:*.shtml=0;38;2;226;209;57:*.patch=0;38;2;0;255;135:*.scala=0;38;2;0;255;135:*.cache=0;38;2;122;112;112:*.ipynb=0;38;2;0;255;135:*TODO.md=1:*.groovy=0;38;2;0;255;135:*INSTALL=0;38;2;0;0;0;48;2;230;219;116:*.gradle=0;38;2;0;255;135:*.matlab=0;38;2;0;255;135:*.config=0;38;2;166;226;46:*.dyn_hi=0;38;2;122;112;112:*LICENSE=0;38;2;182;182;182:*.flake8=0;38;2;166;226;46:*.ignore=0;38;2;166;226;46:*COPYING=0;38;2;182;182;182:*setup.py=0;38;2;166;226;46:*TODO.txt=1:*Makefile=0;38;2;166;226;46:*.desktop=0;38;2;166;226;46:*Doxyfile=0;38;2;166;226;46:*.gemspec=0;38;2;166;226;46:*.rgignore=0;38;2;166;226;46:*README.md=0;38;2;0;0;0;48;2;230;219;116:*.fdignore=0;38;2;166;226;46:*.markdown=0;38;2;226;209;57:*.cmake.in=0;38;2;166;226;46:*configure=0;38;2;166;226;46:*.kdevelop=0;38;2;166;226;46:*.DS_Store=0;38;2;122;112;112:*COPYRIGHT=0;38;2;182;182;182:*.gitignore=0;38;2;166;226;46:*.scons_opt=0;38;2;122;112;112:*CODEOWNERS=0;38;2;166;226;46:*SConscript=0;38;2;166;226;46:*Dockerfile=0;38;2;166;226;46:*INSTALL.md=0;38;2;0;0;0;48;2;230;219;116:*SConstruct=0;38;2;166;226;46:*README.txt=0;38;2;0;0;0;48;2;230;219;116:*.gitconfig=0;38;2;166;226;46:*.localized=0;38;2;122;112;112:*.gitmodules=0;38;2;166;226;46:*Makefile.am=0;38;2;166;226;46:*.synctex.gz=0;38;2;122;112;112:*INSTALL.txt=0;38;2;0;0;0;48;2;230;219;116:*Makefile.in=0;38;2;122;112;112:*.travis.yml=0;38;2;230;219;116:*MANIFEST.in=0;38;2;166;226;46:*LICENSE-MIT=0;38;2;182;182;182:*appveyor.yml=0;38;2;230;219;116:*configure.ac=0;38;2;166;226;46:*.applescript=0;38;2;0;255;135:*.fdb_latexmk=0;38;2;122;112;112:*CONTRIBUTORS=0;38;2;0;0;0;48;2;230;219;116:*.clang-format=0;38;2;166;226;46:*.gitattributes=0;38;2;166;226;46:*CMakeCache.txt=0;38;2;122;112;112:*CMakeLists.txt=0;38;2;166;226;46:*LICENSE-APACHE=0;38;2;182;182;182:*CONTRIBUTORS.md=0;38;2;0;0;0;48;2;230;219;116:*requirements.txt=0;38;2;166;226;46:*CONTRIBUTORS.txt=0;38;2;0;0;0;48;2;230;219;116:*.sconsign.dblite=0;38;2;122;112;112:*package-lock.json=0;38;2;122;112;112:*.CFUserTextEncoding=0;38;2;122;112;112"

