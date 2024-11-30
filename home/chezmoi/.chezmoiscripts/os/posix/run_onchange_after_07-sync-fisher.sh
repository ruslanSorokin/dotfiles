#!/usr/bin/env bash

# fish_plugins hash: {{ include "private_dot_config/fish/fish_plugins" | sha256sum }}
# last check: {{ now | date "2006-01-02" }}

fish <<FISH
  type -q fisher && curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

  fisher update
FISH
