# Unbind <C-j> from Enter
bindkey -r "^J"
# Unbind <C-o> from Enter
bindkey -r "^O"
# Unbind <C-b> from Enter
bindkey -r "^B"
# Unbind <C-p> from prev-command
bindkey -r "^P"
# Unbind <C-n> from next-command
bindkey -r "^N"
# Unbind <C-v>
bindkey -r "^V"

bindkey "^J" down-line-or-beginning-search
bindkey "^K" up-line-or-beginning-search

bindkey "^B" backward-word
bindkey "^N" forward-word

bindkey "^O" backward-char
bindkey "^P" forward-char

bindkey "^A" backward-kill-word
bindkey "^Z" kill-word

bindkey "^ " accept-line
