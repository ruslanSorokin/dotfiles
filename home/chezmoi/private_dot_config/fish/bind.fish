function bind_all -a key cmd
    bind -M insert $key $cmd
    bind -M visual $key $cmd
    bind -M default $key $cmd
end

bind -M default E forward-single-char forward-bigword backward-char # see: https://github.com/fish-shell/fish-shell/issues/10790

bind_all \et htop
bind_all \ey y # yazi
bind_all \ez zellij
bind_all \ec sshs
bind_all \ee $EDITOR
bind_all \eg lazygit

set -l up_k 'commandline -P; and up-or-search; or commandline -i k'
set -l down_j 'commandline -P; and down-or-search; or commandline -i j'
set -l left_h 'commandline -P; and commandline -f backward-char; or commandline -i h'
set -l right_l 'commandline -P; and commandline -f forward-char; or clear_scrollback_buffer && commandline -f repaint; or commandline -i l'

bind_all \ck $up_k
bind_all \cj $down_j
bind_all \ch $left_h
bind_all \cl $right_l

set -l up_p 'commandline -P; and up-or-search; or commandline -i p'
set -l down_n 'commandline -P; and down-or-search; or commandline -i n'

bind_all \cp $up_p
bind_all \cn $down_n

bind \cl 'clear_scrollback_buffer && commandline -f repaint; or commandline -i l'

bind -M insert \e\cg _fzf_search_git_log
bind \e\cg _fzf_search_git_log
