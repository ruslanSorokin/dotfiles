function __fish_git_complete_worktrees_without_bare
    __fish_git worktree list --porcelain | sed --regexp-extended -z --expression 's/^worktree (.*)\nbare\n//g' | string replace --regex --filter '^worktree\s*' ''
end

function __fish_git
    set -l saved_args $argv
    set -l global_args
    set -l cmd (commandline -opc)
    # We assume that git is the first command until we have a better awareness of subcommands, see #2705.
    set -e cmd[1]
    if argparse -s (__fish_git_global_optspecs) -- $cmd 2>/dev/null
        # All arguments that were parsed by argparse are global git options.
        set -l num_global_args (math (count $cmd) - (count $argv))
        if test $num_global_args -ne 0
            set global_args $cmd[1..$num_global_args]
        end
    end
    # Using 'command git' to avoid interactions for aliases from git to (e.g.) hub
    # Using eval to expand ~ and variables specified on the commandline.
    eval command git $global_args \$saved_args 2>/dev/null
end

# Print an optspec for argparse to handle git's options that are independent of any subcommand.
function __fish_git_global_optspecs
    string join \n v-version h/help C= c=+ 'e-exec-path=?' H-html-path M-man-path I-info-path p/paginate \
        P/no-pager o-no-replace-objects b-bare G-git-dir= W-work-tree= N-namespace= S-super-prefix= \
        l-literal-pathspecs g-glob-pathspecs O-noglob-pathspecs i-icase-pathspecs
end
