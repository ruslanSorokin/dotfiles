#!/usr/bin/env bash

fish <<FISH
  type -q tide && tide configure \
    --auto  \
    --style=Rainbow  \
    --prompt_colors='True color'  \
    --show_time=No  \
    --rainbow_prompt_separators=Slanted  \
    --powerline_prompt_heads=Sharp  \
    --powerline_prompt_tails=Sharp  \
    --powerline_prompt_style='Two lines, frame'  \
    --prompt_connection=Solid  \
    --powerline_right_prompt_frame=Yes  \
    --prompt_connection_andor_frame_color=Lightest  \
    --prompt_spacing=Sparse  \
    --icons='Many icons'  \
    --transient=No
FISH
