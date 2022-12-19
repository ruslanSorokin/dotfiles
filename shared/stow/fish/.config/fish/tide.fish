set -l white e5e5e5
set -l red ff6188
set -l orange fc9867
set -l dark_purple 9d65ff
set -l light_purple ab9df2
set -l blue 78dce8
set -l green a9dc76
set -l yellow ffd866

# Right prompt
# status cmd_duration context jobs direnv node python rustc java php pulumi ruby go gcloud docker kubectl distrobox toolbox terraform aws nix_shell crystal elixir 
set -x tide_right_prompt_items status cmd_duration context jobs direnv node python rustc java php pulumi ruby go gcloud distrobox toolbox terraform aws nix_shell crystal elixir 

# Docker
set -x tide_docker_bg_color 0db7ed
set -x tide_docker_default_contexts ''

# Kubectl
set -x tide_kubectl_bg_color 3970e4

# Status
set -x tide_status_color black
set -x tide_status_bg_color $white
set -x tide_status_color_failure black
set -x tide_status_bg_color_failure $red
set -x tide_status_icon 
set -x tide_status_icon_failure 

# Cmd duration
set -x tide_cmd_duration_color black
set -x tide_cmd_duration_bg_color $yellow

# Jobs
set -x tide_jobs_color black
set -x tide_jobs_bg_color $green

# OS
set -x tide_os_color black
set -x tide_os_bg_color $white


# Git
set -x tide_git_bg_color $green
set -x tide_git_bg_color_unstable $orange
set -x tide_git_bg_color_urgent $red
set -x tide_git_color_branch black
set -x tide_git_color_conflicted $red
set -x tide_git_color_dirty black
set -x tide_git_color_operation $white
set -x tide_git_color_staged black
set -x tide_git_color_stash black
set -x tide_git_color_untracked black
set -x tide_git_color_upstream black
set -x tide_git_icon 
set -x tide_git_truncation_length 60


# Vi mode
set -x tide_vi_mode_bg_color_default $orange
set -x tide_vi_mode_color_default black
set -x tide_vi_mode_bg_color_insert $yellow
set -x tide_vi_mode_color_insert black
set -x tide_vi_mode_bg_color_replace $blue
set -x tide_vi_mode_color_replace black
set -x tide_vi_mode_bg_color_visual $light_purple
set -x tide_vi_mode_color_visual black

# PWD
set -x tide_pwd_bg_color $dark_purple
set -x tide_pwd_color_anchors $white
set -x tide_pwd_color_dirs $white
set -x tide_pwd_color_truncated_dirs $white

