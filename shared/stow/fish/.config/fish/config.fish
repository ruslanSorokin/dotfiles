set -x fish_greeting ""
fish_vi_key_bindings
fish_config theme choose ayu\ Mirage

if status is-login
    set -x SHELL fish
    # ---------------------------------------------------------------------------- #
    #                                 File sourcing                                #
    # ---------------------------------------------------------------------------- #

    source $XDG_CONFIG_HOME/fish/pure.fish
    source $XDG_CONFIG_HOME/fish/tide.fish
    source $XDG_CONFIG_HOME/fish/functions/git_completions_helpers.fish


    for item in tmux code nvim vim vi
        if not contains $item $__done_exclude
            set -U --append __done_exclude $item
        end
    end
end

if status is-interactive
  mise activate fish | source
end


# ---------------------------------------------------------------------------- #
#                                    Aliases                                   #
# ---------------------------------------------------------------------------- #
alias asdf "mise"

alias ll="eza --long --icons --group-directories-first --time changed --all --links --colour-scale size"
alias l="eza --long --icons --group-directories-first --time changed --no-permissions --no-filesize"

alias lst="ls --tree"
alias llt="ll --tree"
alias lt="l --tree"

alias sudo='sudo -E env "PATH=$PATH"'

alias ugpg="rm ~/.gnupg/public-keys.d/pubring.db.lock"

if test $(string match '*WSL*' $(uname -a))
  alias podman="podman --remote"
end

if test $(uname) = Linux
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
end

if test $(string match '*WSL*' $(uname -a))
    alias open="wslview"
end

if test $(string match '*WSL*' $(uname -a))
    set --local inboxPath "/mnt/c/WSL/Inbox/"
    alias cp2win="cp -t $inboxPath"
    function cp2wsl -V inboxPath
      cp $inboxPath$argv .
    end
    complete -f -c cp2wsl -a "(ls $inboxPath)"
end


alias codego="code --profile Golang"
alias codecs="code --profile CSharp"
alias codepb="code --profile Protobuf"
alias codepy="code --profile Python"
alias coders="code --profile Rust"
alias codesc="code --profile Scala"

# ---------------------------------------------------------------------------- #
#                                     Keys                                     #
# ---------------------------------------------------------------------------- #
bind -M insert \cj 'commandline -P; and down-or-search; or commandline -i j'
bind -M insert \ck 'commandline -P; and up-or-search; or commandline -i k'
bind -M insert \ch 'commandline -P; and commandline -f backward-char; or commandline -i h'
bind -M insert \cl "commandline -P; and commandline -f forward-char; or clear_scrollback_buffer && commandline -f repaint; or commandline -i l"

bind -M insert \cn 'commandline -P; and down-or-search; or commandline -i n'
bind -M insert \cp 'commandline -P; and up-or-search; or commandline -i p'

bind \cl "clear_scrollback_buffer && commandline -f repaint; or commandline -i l"

bind -M insert \e\cg _fzf_search_git_log
bind \e\cg _fzf_search_git_log

# ---------------------------------------------------------------------------- #
#                                 Abbreviations                                #
# ---------------------------------------------------------------------------- #

abbr -a sc "source $__fish_config_dir/config.fish"

abbr -a wo -p anywhere "&>/dev/null"
abbr -a wl -p anywhere "2>&1"
abbr -a wi "type -P"
abbr -a hd "history delete"

# --------------------------------- Homebrew --------------------------------- #
abbr -a brup "brew update --auto-update && brew upgrade"
abbr -a brcl "brew cleanup --prune=all && brew autoremove"
abbr -a brall "brew update --auto-update && brew upgrade && brew cleanup --prune=all && brew autoremove"
abbr -a brbd "brew bundle dump --brews --taps"
abbr -a brbc "brew bundle check"
abbr -a afu "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"

# ------------------------------------ Git ----------------------------------- #
#

abbr -a gec "git commit -m 'Empty commit' --allow-empty"

abbr -a gstar "git stash --keep-index --include-untracked -m"
abbr -a gstas "git stash --staged"

abbr -a glap "git pull --all --prune"
abbr -a gbr "git branch -vv -r"

abbr -a gds "git diff --staged"
abbr -a gdst "git diff --stat"

abbr -a glgo "git log --oneline"
abbr -a glgon "git log --oneline -n"

abbr -a gbm "git branch -m"

abbr -a gcfxn "git commit --no-verify --fixup"
abbr -a grbifx "git rebase --interactive --autosquash"

abbr -a grr "git restore"
abbr -a grrs "git restore --staged"

abbr -a grts "git reset --soft"
abbr -a grth "git reset --hard"

abbr -a gwtrp "git worktree repair"

abbr -a gwtn "git wtn"

abbr -a gwta "git wta"
complete -f -c git -n '__fish_git_using_command wta' -ka '(__fish_git_local_branches)' -d Branch
complete -f -c git -n '__fish_git_using_command wta' -ka '(__fish_git_tags)' -d Tag

abbr -a gbcp "git bcp"
complete -f -c git -n '__fish_git_using_command bcp' -ka '(__fish_git_unique_remote_branches)' -d 'Unique Remote Branch'

abbr -a glgos "git log --oneline --show-signature"

abbr -a gp!! "git push --force-with-lease"
abbr -a gp! "git push --force-with-lease --force-if-includes"

complete -c vi -a '(__fish_git_complete_worktrees_without_bare)' -d Worktree
complete -c vim -a '(__fish_git_complete_worktrees_without_bare)' -d Worktree
complete -c nvim -a '(__fish_git_complete_worktrees_without_bare)' -d Worktree

complete -c code -a '(__fish_git_complete_worktrees_without_bare)' -d Worktree

# ---------------------------------- Golang ---------------------------------- #
abbr -a gmt "go mod tidy"
abbr -a gtba "go test -run='^\$' -bench='.'"
abbr -a gtb "go test -run='^\$' -bench="
abbr -a gtbar "go test ./... -run='^\$' -bench='.'"
abbr -a gtbr "go test ./... -run='^\$' -bench="

# ---------------------------------- Docker ---------------------------------- #

abbr -a dki "docker inspect"
abbr -a dkif "docker inspect --format '{{json .Config}}'"

abbr -a dknl "docker network ls"
abbr -a dkn "docker network"
abbr -a dknn "docker network create"
abbr -a dknc "docker network connect"
abbr -a dknd "docker network disconnect"
abbr -a dknpr "docker network prune"
abbr -a dknrm "docker network rm"



brew shellenv | source

zoxide init --cmd cd fish | source

mise activate fish --shims | source

source ~/.local/share/mise/plugins/dotnet-core/set-dotnet-home.fish

# ---------------------------------------------------------------------------- #
#                               FZF configuration                              #
# ---------------------------------------------------------------------------- #
set -x fzf_preview_dir_cmd tree --dirsfirst -C -L 5
set -x fzf_preview_file_cmd bat --color always

set -x fzf_fd_opts --hidden --no-ignore --exclude={.git,.idea,.vscode,.sass-cache,node_modules}
set -x fzf_diff_highlighter diff-so-fancy
set -x fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

